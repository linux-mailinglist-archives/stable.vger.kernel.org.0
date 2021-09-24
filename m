Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6542C41791E
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 18:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhIXQzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 12:55:46 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:33320 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhIXQzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 12:55:45 -0400
Received: by mail-pg1-f182.google.com with SMTP id 81so6874362pgb.0;
        Fri, 24 Sep 2021 09:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2xqE3aDEDxSgJ9vdly0nyHR5jt7X0bYztaO7njOJ4jY=;
        b=KknOjn1QxYRGqjZRKIAju3uOW5HiYepbi/XTQK98QQM53o1ZOWv5NJ+Tq7ieg6Snw0
         qQlYJWpWsOrsdYkAU81xRJPrZOuWC68fytnHpCMX6wBLrnsLHmQdXihc42cyIweKkAzG
         pP9dhdpoL6ut7346Yn7iRUw/KUDyZeYrxTckaWgk3FFZDUrjd4MduwIoXWGr6jRDT6s/
         bjJUhEifrLl7gn1Q+jX5qbSrbLpCirSQ2ggOHpUOCAvE5QktCkaGBu/zlHWJiBn1Mmrh
         lbE+/4P+MeWAYMRb9podC4Lad9FsqicjgcFALG6VElWGcbbi8Y6ohQalI5uHijSCk4Oi
         Bedw==
X-Gm-Message-State: AOAM530Vuo5z6XP+kGXIS+w8EPWGGCEukWUTLLCegv9txTlkYejzdhN4
        10B3q+4DXbAsX6xnhtko/cw7krtYGPc=
X-Google-Smtp-Source: ABdhPJz52ICrkQo5W5bfh525OWNTTCOultL2rNlRhs96xC5H8oT3uHPh0I4Q/PN81OD71EoWTqIRMQ==
X-Received: by 2002:a63:5c63:: with SMTP id n35mr4555827pgm.311.1632502451668;
        Fri, 24 Sep 2021 09:54:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf91:ebe7:eabf:7473])
        by smtp.gmail.com with ESMTPSA id c7sm9196712pfd.75.2021.09.24.09.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:54:10 -0700 (PDT)
Subject: Re: [PATCH v4 1/1] scsi: ufs: Fix illegal address reading in upiu
 event trace
To:     Jonathan Hsu <jonathan.hsu@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        alice.chao@mediatek.com, powen.kao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, wsd_upstream@mediatek.com,
        stable@vger.kernel.org
References: <20210924085848.25500-1-jonathan.hsu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e2d4568b-63e7-d9f9-83b9-63cb68c518a6@acm.org>
Date:   Fri, 24 Sep 2021 09:54:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924085848.25500-1-jonathan.hsu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 1:58 AM, Jonathan Hsu wrote:
> Fix incorrect index for UTMRD reference in ufshcd_add_tm_upiu_trace().
> 
> Fixes: 4b42d557a8ad ("scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonathan Hsu <jonathan.hsu@mediatek.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
