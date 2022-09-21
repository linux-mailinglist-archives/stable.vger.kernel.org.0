Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE6E5C0446
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiIUQfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiIUQfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:35:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FAFA2842
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663777058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FfcSWDyvK8gG5N4a1A9EOaJbBSk6wOatfd9ejRCTkqM=;
        b=i3SG3/n9U5uqIDJg1Ytb/pVHWxKNguZ8x+NcF4DRC9WI+zXy5hLyIyV3fKY+9FW0twezt4
        sdFX1Kv1pQs1RKyRAe7lavbpogq8Wlt2cjp45Kh3QN1Op4mppozpe05Yek6KPXd9wSdj3z
        qjDNlrWcNJddIFi4rnfQhAImTdqXKlo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-zxPj7EvON3K8aIkfyxABrw-1; Wed, 21 Sep 2022 12:17:36 -0400
X-MC-Unique: zxPj7EvON3K8aIkfyxABrw-1
Received: by mail-ed1-f72.google.com with SMTP id f10-20020a0564021e8a00b00451be6582d5so4801251edf.15
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:17:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=FfcSWDyvK8gG5N4a1A9EOaJbBSk6wOatfd9ejRCTkqM=;
        b=7njihjuOTtiiyEsLf5YFV4AjcMhciG9R3+9Mcttk9txqoW3XIa3K6Hm/jEVEbKRPLb
         u/n/ih03gwudzbdTuewWimjCggaoGqdInJNpC6u0miYCUyo81pBTxsdFnlglkvR3op0X
         VPt0FxZgV7Zb+JkvGy3a/5YymtTzpm2C0FOw/t8awrYbinVo3ZvjBb+tyRHDsloh9Ade
         rF2scwux5RZyJaOR4NDuJV772T2Qs4vCl2RSoCujmaDddZHZ1C4O/z5/F/LyyclQbfg1
         SPbi79bcrXO1JV1znIvBBQl/J76CSwiuAq0PgiAz7L9w4Kgcax9Ssn/2K+MaQPLXV3De
         xZyA==
X-Gm-Message-State: ACrzQf1n2VBEPuFNV89HU2itkj+ntuAEPv3wz07eQWW61t0q6REBQzXy
        F22MBr0lwyWGpXRsRrpvYylYkO/CziKyuLV/OljPZVtoeKh7S7ixguCI/l/XvGMRgH6C9cS3Uo7
        7udjZYS5Cm956iYZtOmmc8vXF8C6ZQk/osPzdbRIpQjNic6D8yqZHbgpSf6Ng4/9aPmCZ
X-Received: by 2002:aa7:d617:0:b0:44e:d2de:3fe1 with SMTP id c23-20020aa7d617000000b0044ed2de3fe1mr26164146edr.104.1663777055867;
        Wed, 21 Sep 2022 09:17:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM58VTewJJPKmz/ZoiZ0+8xhb98FXISDzqGdAWAP+DQt5crsRNfxwSLeqyF4RjyCWlLrJmoQTA==
X-Received: by 2002:aa7:d617:0:b0:44e:d2de:3fe1 with SMTP id c23-20020aa7d617000000b0044ed2de3fe1mr26164112edr.104.1663777055583;
        Wed, 21 Sep 2022 09:17:35 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j26-20020a170906255a00b0073dde62713asm1428988ejb.89.2022.09.21.09.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:17:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 01/16] Drivers: hv: Never allocate anything
 besides framebuffer from framebuffer memory region
In-Reply-To: <20220921155332.234913-1-sashal@kernel.org>
References: <20220921155332.234913-1-sashal@kernel.org>
Date:   Wed, 21 Sep 2022 18:17:34 +0200
Message-ID: <87illgog69.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> [ Upstream commit f0880e2cb7e1f8039a048fdd01ce45ab77247221 ]
>

(this comment applies to all stable branches)

While this change seems to be worthy on its own, the underlying issue
with Gen1 Hyper-V VMs won't be resolved without 

commit 2a8a8afba0c3053d0ea8686182f6b2104293037e
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Sat Aug 27 15:03:44 2022 +0200

    Drivers: hv: Always reserve framebuffer region for Gen1 VMs

as 'fb_mmio' is still going to be unset in some cases without it.

-- 
Vitaly

