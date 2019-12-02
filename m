Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520EE10F35B
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 00:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLBXYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 18:24:52 -0500
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38414 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfLBXYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 18:24:52 -0500
Received: by mail-pj1-f54.google.com with SMTP id l4so553241pjt.5
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 15:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YLvsWzioAA9l5IHqvEV2BPAetrXvTSbn49dnm+84m+8=;
        b=hZ3eU9pFbn1mClWI0DBarz26DI+/BKgtrUNf3SK0aHFevcFuajYrlu/43Or0ydCOtr
         KgynehYDq8vERMMvJc7d9hkjHxM7oTWJWxKHBP0JnKazRdCEcRD2jg4eW1xav8bW3Uzw
         fuhjBVi3o5Tqsghr7e7ip7FSSC6GYQP3s2z+cxL5EI4QyhJj+Lr8pKDdUZjm0omVholN
         qz9enMrL+y72KJt++OEYtdTTrMZeiu13TKbMeRjmpSRi+W1mdWu+GfBrq5mv68j+V3VG
         OIuGA28QYcA0AfHyVXTFtZmxXKPcSS5OTnmfR1gvxmAFlHRftLU5YA0T0Efj/NK1sk0f
         W0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YLvsWzioAA9l5IHqvEV2BPAetrXvTSbn49dnm+84m+8=;
        b=VY9XvN/5Fi84yNObrJBBR+Bi550Q2dOVNxYYZB8y49iOKUhEceb4cTd3wC7MAozCGz
         49scFNssmZHPtLcxi22BOV3g9kzuvTxizMIY5FKtCAQi0W9xVBrelNyqfSU9HtsKsgOo
         QLpD44CrRoK2Ia80r3WXZfEGiFnjsmTi516kfZceiQR671tExbDk9B5e8m5ucgzOjt1e
         /JDnkPXEuaar3cnpDHYAxuA7dAmKi8pUWGKIgq1EPDF1eAzzxprFMiSMjm3tOP6coafz
         c+yWNi3eM4MP5J1KQoZVM/2G+uW4udOo/3hlD9oFbd+70AOWT1/P/mhuy6vRdIPbwx5T
         EIcw==
X-Gm-Message-State: APjAAAVIDlo6r+XN3p6whSLNnd0nvNixLBNnxiZecAaoNjzDXUV7jzv9
        AY8Az+GSVN6Alc7ZVtoyGmCaifaq5UU=
X-Google-Smtp-Source: APXvYqzMvYXQhbmfDP0dOzeItYRCyXomDFSzOE4wdgGCUEDuJNSO9v7EnSRrELzcFklxd56zPfCozw==
X-Received: by 2002:a17:902:988a:: with SMTP id s10mr1712582plp.315.1575329091012;
        Mon, 02 Dec 2019 15:24:51 -0800 (PST)
Received: from gnomeregan.cam.corp.google.com ([2620:15c:6:14:ad22:1cbb:d8fa:7d55])
        by smtp.googlemail.com with ESMTPSA id b24sm575101pfi.148.2019.12.02.15.24.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 15:24:50 -0800 (PST)
From:   Barret Rhoden <brho@google.com>
Subject: x86/fpu: Don't cache access to fpu_fpregs_owner_ctx
To:     stable@vger.kernel.org
Message-ID: <edb74a15-c20d-2a8e-0560-97c038541ab6@google.com>
Date:   Mon, 2 Dec 2019 18:24:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 59c4bd853abcea95eccc167a7d7fd5f1a5f47b98 upstream

Hi -

Please apply to 5.4.  This commit fixes floating point register 
corruption that became triggerable starting with v5.2.

Thanks,

Barret

