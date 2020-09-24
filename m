Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CE9277337
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 15:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgIXN60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 09:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgIXN60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 09:58:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FB9C0613D3
        for <stable@vger.kernel.org>; Thu, 24 Sep 2020 06:58:26 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mn7so1644055pjb.5
        for <stable@vger.kernel.org>; Thu, 24 Sep 2020 06:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=JTIwwGCyjcq0mpAoKgo0NQgCSb/D31dPrktopvYLFIQ=;
        b=WtFukAOJyKMc1u3SUdM1K3S2Ye9+BBTG3BhgM5TxBp48RXolWoEw4iWmYzPdJ9beSb
         d37eXjR9OFK61j5hRggTrIpr4zhM1Bsyso/UFbIWmr+Vumb0M/qZ18kaF2KlN+xsIUXm
         SVoRWqeZQUm8Jsyqkw2J45ueY4qc627udvGR018j5c43WQxztpVKEbvLq+yUKbKwHTuU
         /0QX88EAzTQk8dEsOlOwoRgXcMN608fVhRaOMfwj6fzwZCL46p1t5zpEVnNINoHrs7/0
         359mN5n5a3sz+kagK6fOtIEB4K1PQQpKRFK63tcGuBuj4WopfVI7zGyOJJejqoasKUnz
         a56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=JTIwwGCyjcq0mpAoKgo0NQgCSb/D31dPrktopvYLFIQ=;
        b=SRoHR8qqIWyNJ7vUtQTanX2UXsT1Fp9v08d4/+aWh6Nv3XymejFYlmE84LL3fCx47x
         ixKMbadaZobylYKRl+hLiHAslruCD8oEFgfOt/1cUXGIFbUfYCcXL6o8AcWCyTJ4rlt/
         M1i+8M/YkIUq7zjAYB4/sBJT6Sy3BlaJp6heUnQbkrypLtCaYZSGK83orEfRMe9aiFmo
         j0l13OOjXjq8rcaTyavlD3mB98xrN3r0oEgHrbMWyToMX1bel78CRXTUsE45ewkqxGX8
         lJ8CJQR+Yul1ZvSRqKojtj4G4GVJdQ0qj0qpSPbLGnVTbf/cp3cBMgqsvhrDzzr8ViFQ
         IsJg==
X-Gm-Message-State: AOAM531zYhNSJDc8YU86ltrM8fJ2ASdQ+yb58nMPQi1AxWfowWpK5BPt
        xr+a2bgfYwtRMeqplh1k+6qreHdxttcf/Q==
X-Google-Smtp-Source: ABdhPJz2VJ4p6NgFj2hjs/jD4JkCQbpVEgmhEsrYI9KWLiCZxCMMtb6rg2lKnqseuMrlxxRof3Gouw==
X-Received: by 2002:a17:902:ed41:b029:d1:cbf4:bdac with SMTP id y1-20020a170902ed41b02900d1cbf4bdacmr4778249plb.40.1600955905408;
        Thu, 24 Sep 2020 06:58:25 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:4a0f:cfff:fe35:d61b])
        by smtp.googlemail.com with ESMTPSA id b4sm2530285pjz.22.2020.09.24.06.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 06:58:24 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Mark Salyzyn <salyzyn@android.com>
Subject: commit 37bd22420f85 ("af_key: pfkey_dump needs parameter validation")
 to stable
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, kernel-team@android.com
Message-ID: <75492c42-5081-d988-5a9b-8dc269661e8c@android.com>
Date:   Thu, 24 Sep 2020 06:58:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider

commit 37bd22420f856fcd976989f1d4f1f7ad28e1fcac ("af_key: pfkey_dump 
needs parameter validation")

for merge into all the maintained stable trees.

Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

