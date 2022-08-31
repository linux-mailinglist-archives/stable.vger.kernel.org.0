Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFFE5A867C
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 21:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiHaTM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 15:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHaTMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 15:12:25 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD59ED83D9;
        Wed, 31 Aug 2022 12:12:23 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id w18so11591506qki.8;
        Wed, 31 Aug 2022 12:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc;
        bh=BlRf7W3x/ZYNwUL/i+8WPajC7eIKtq4rRsLFRUO00UY=;
        b=VwDMh3hjO0mzYMUaX3Gbi5C12cnleNpGMjqWcA82t/sPm5YtWOnSoguxQgUtFIvyHj
         3F9+/03fOnPYbWbhTGNudrydWLgzabdo5uAOFkym9KE6GN1S6Qw2Oly0JHnNVdhE4Aon
         OUn+o5Q+rshbxHEiEteg4YJJmR3Bjm/0JPKiVycMblC1caVgs9FEgLi/5bW0vM/8bbpT
         chLurFdKNEi3Mcb/IUB9rVKT8Qbjcp48YyFSpyfDlPl5uCXSM/ijCHlsLz2nzccyK4io
         4gwIJew9HfMPiTUEnFMG9HOSKi3qdqlg4Frtk6kkjRbHWc+8ncSZiMevOUzU4OlXa1H8
         Db4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc;
        bh=BlRf7W3x/ZYNwUL/i+8WPajC7eIKtq4rRsLFRUO00UY=;
        b=qxQNQra2P7UO85sUqaRsrn2Xqo8WFEufXRCWFnPQ7I7HfiDSvuFyrFyvcQpJsmGMSs
         p/ji2082r6V8WMEd/jP5CcnF9yGnlzJI0nUQF+lv4xfgHLtZl7ZlHi3tjs6VqDvZqkOg
         FnYERs/od4fpWZ/v0hYhVNdjyHByXR5cvBlPf97oqmj4/Elp11yY7IB3D0POJheJFd1k
         9T/ndEPbPLh7YetUfLwMtdqAlcWdX0Zj6q1FPiwWTyFoz8o1bewlK5wDBLAE3XHsZ3Ae
         XnyY23/uWZA0XTIsyRruAbiVedWIHAEuhTPCIE+B/HniKBcUvPZbqdp12xIQWLD4esA/
         Vy+w==
X-Gm-Message-State: ACgBeo33Om2c5b2ZKOR2Xglr1AqoH/zmnqLXCBetR2sF/QiJYlom6o/u
        V/5ErB4k/SKvJG/aH+zTX+h429Q5QBs=
X-Google-Smtp-Source: AA6agR440czcs4X1aV4EzQ4AiT3FymTTvuCugfm3euv1cnTiNJ342KELuSCOBVZvIJrQlrR0YSdFqA==
X-Received: by 2002:a05:620a:b02:b0:6bb:ebe:248b with SMTP id t2-20020a05620a0b0200b006bb0ebe248bmr16654670qkg.420.1661973142873;
        Wed, 31 Aug 2022 12:12:22 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id ge17-20020a05622a5c9100b003430589dd34sm9095655qtb.57.2022.08.31.12.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 12:12:22 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailauth.nyi.internal (Postfix) with ESMTP id 7DC9827C0054;
        Wed, 31 Aug 2022 15:12:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 31 Aug 2022 15:12:20 -0400
X-ME-Sender: <xms:lLIPYxB3qTvX1-AkkQAcOIBgelkbwoykY_cp_swDtqbyC87vsYoB-Q>
    <xme:lLIPY_gt1pI0QNlxYdwk_X0gGqm0BjEdOgZ5j_EOdtickj-9rD28z_B_Rrm40qvcu
    YuF7uYMBFBzWUF_UQ>
X-ME-Received: <xmr:lLIPY8m6flquFM3dYY5TPOkgjgRT1PE8LCaYykB7XK8QuddW-XPfJ2m6vtM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdekiedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:lLIPY7yJ9SfImoLUIqOW7RQSJf5ctfc76SEk4pWazSIfNQrZ6MztKw>
    <xmx:lLIPY2RR3tpdj1xWTrdavcmzL5chOJHsilhOfVPxE8x8Y_21BMDBXw>
    <xmx:lLIPY-Yb3y6Deh6xSc5e0RVFs4gvIAsFEv35COKTpc9qN5y5MguUAg>
    <xmx:lLIPY9KbY3Gm4O3b5YR9NSXwm3Xa3QZHqBtELxJRzEnJt3x0ufV-tg>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 31 Aug 2022 15:12:19 -0400 (EDT)
Date:   Wed, 31 Aug 2022 12:11:20 -0700
From:   Boqun Feng <boqun.feng@gmail.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v2 1/2] Drivers: hv: balloon: Support status report for
 larger page sizes
Message-ID: <Yw+yWFFpU+mwT97H@boqun-archlinux>
References: <20220325023212.1570049-1-boqun.feng@gmail.com>
 <20220325023212.1570049-2-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325023212.1570049-2-boqun.feng@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I think we also want this patch in the 5.15 stable. Without this patch,
hv_balloon() will report incorrect memory usage to hypervisor when
running on ARM64 with PAGE_SIZE > 4k. Only 5.15 needs this because ARM64
support of HyperV guests arrived in 5.15.

Upstream id b3d6dd09ff00fdcf4f7c0cb54700ffd5dd343502

Cc: <stable@vger.kernel.org> # 5.15.x

Thanks!

Regards,
Boqun

On Fri, Mar 25, 2022 at 10:32:11AM +0800, Boqun Feng wrote:
> DM_STATUS_REPORT expects the numbers of pages in the unit of 4k pages
> (HV_HYP_PAGE) instead of guest pages, so to make it work when guest page
> sizes are larger than 4k, convert the numbers of guest pages into the
> numbers of HV_HYP_PAGEs.
> 
> Note that the numbers of guest pages are still used for tracing because
> tracing is internal to the guest kernel.
> 
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  drivers/hv/hv_balloon.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index f2d05bff4245..062156b88a87 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -17,6 +17,7 @@
>  #include <linux/slab.h>
>  #include <linux/kthread.h>
>  #include <linux/completion.h>
> +#include <linux/count_zeros.h>
>  #include <linux/memory_hotplug.h>
>  #include <linux/memory.h>
>  #include <linux/notifier.h>
> @@ -1130,6 +1131,7 @@ static void post_status(struct hv_dynmem_device *dm)
>  	struct dm_status status;
>  	unsigned long now = jiffies;
>  	unsigned long last_post = last_post_time;
> +	unsigned long num_pages_avail, num_pages_committed;
>  
>  	if (pressure_report_delay > 0) {
>  		--pressure_report_delay;
> @@ -1154,16 +1156,21 @@ static void post_status(struct hv_dynmem_device *dm)
>  	 * num_pages_onlined) as committed to the host, otherwise it can try
>  	 * asking us to balloon them out.
>  	 */
> -	status.num_avail = si_mem_available();
> -	status.num_committed = vm_memory_committed() +
> +	num_pages_avail = si_mem_available();
> +	num_pages_committed = vm_memory_committed() +
>  		dm->num_pages_ballooned +
>  		(dm->num_pages_added > dm->num_pages_onlined ?
>  		 dm->num_pages_added - dm->num_pages_onlined : 0) +
>  		compute_balloon_floor();
>  
> -	trace_balloon_status(status.num_avail, status.num_committed,
> +	trace_balloon_status(num_pages_avail, num_pages_committed,
>  			     vm_memory_committed(), dm->num_pages_ballooned,
>  			     dm->num_pages_added, dm->num_pages_onlined);
> +
> +	/* Convert numbers of pages into numbers of HV_HYP_PAGEs. */
> +	status.num_avail = num_pages_avail * NR_HV_HYP_PAGES_IN_PAGE;
> +	status.num_committed = num_pages_committed * NR_HV_HYP_PAGES_IN_PAGE;
> +
>  	/*
>  	 * If our transaction ID is no longer current, just don't
>  	 * send the status. This can happen if we were interrupted
> -- 
> 2.35.1
> 
