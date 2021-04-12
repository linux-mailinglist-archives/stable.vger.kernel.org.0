Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932E835C480
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 12:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhDLK6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 06:58:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37786 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbhDLK6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 06:58:36 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lVuGn-00019M-D0
        for stable@vger.kernel.org; Mon, 12 Apr 2021 10:58:17 +0000
Received: by mail-wr1-f69.google.com with SMTP id a6so5863915wro.15
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 03:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8XeKPoFNJZJ/zYfxOaZlGtZAu5O/fZfL8ApT/Z776gs=;
        b=Ta0v/3ndaHQFhXy/BGThUFxrQibC9c09NzYTV+0jgNz5NJRJl2rRhnLVYCpc1WLSlX
         nO9ioujIjnRDjxgAqeQTokteNTa3hu4hSC+oX+kPW//Lih4rvaWZ5vktHxtkppCfa31J
         diF+K0C7OTAFnai/zlxmf0u8CURGhQE7/cQeYS4U51sHCn775yj1v+noTM6rG40Ez8RX
         hsSmlOuD/YcPo8IdpxGr/BZQn6yckqkBiAAMh6u+TjCXK4WTR3+mqmWAMa2yOMlwYQKL
         SIqxWmsEnrrEVXw+WV3ktmwlSUua/49YY3ap8czPFLvOOcXMJp5yDuu6bNXBABcvHTZj
         +/9A==
X-Gm-Message-State: AOAM530VY7moSve2TpjVDOVcBnGVpVVRVMjz8601b2lvIdqOXk03jyID
        IHEtD6cPoX3zYn/w+S0Non2bGlyts+d1IqDCrMHIzmUETrIxi4qhtKPxRQpmBXvuNB58ZRqqtyN
        uqjxStLSO0C7xwfVJyHQbvlKbzhsI/ldqJA==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr6948992wrt.60.1618225097103;
        Mon, 12 Apr 2021 03:58:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf1APvrlVbRyJi3UgD/geIOkmnEOpo98qQXY5YDuZ/kFsKGmzqYULwY3cMkDvdo0AJndkqPA==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr6948980wrt.60.1618225096978;
        Mon, 12 Apr 2021 03:58:16 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-192-147.adslplus.ch. [188.155.192.147])
        by smtp.gmail.com with ESMTPSA id o5sm14296936wmc.44.2021.04.12.03.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 03:58:16 -0700 (PDT)
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Newer stable-tools
Message-ID: <f6ad8f77-6dd7-647e-5d4a-983754ba8442@canonical.com>
Date:   Mon, 12 Apr 2021 12:58:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha and everyone,

I am looking at stable-tools from Sasha [1] in hope in re-using it. The
problem I want to solve is to find easier commits in the distro tree,
which were fixed or reverted upstream. Something like steal-commits from
the stable-tools [1].

However the tools themself were not updated since some time and have
several issues, so the questions are:
1. Do you have somewhere updated version which you would like to share?
2. Do you have other stable-toolset which you could share?

https://git.kernel.org/pub/scm/linux/kernel/git/sashal/stable-tools.git/

Best regards,
Krzysztof
