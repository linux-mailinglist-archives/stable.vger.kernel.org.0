Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26C25A4FC2
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiH2PDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 11:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiH2PDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 11:03:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CD084EC8;
        Mon, 29 Aug 2022 08:03:14 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h11-20020a17090a470b00b001fbc5ba5224so8871038pjg.2;
        Mon, 29 Aug 2022 08:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=hl19yC27qvJPGzvVoFgwuG8P3RA3WT4VWzdG/9QIu5c=;
        b=N1pIhGD3wyaigKJVuMP6jb4oj231Asc43jUz5tjVhjk5bTdEAAcjlu+xAvZU/qb9+m
         1m5qLiwFAUAIcOjaHfMSChJoyufmA6Zxclf8RU9S0ixKv80UoHtL5WOqQbTrCT5xznXF
         i/DS01nwtIF3d68Na5mCvQV6XHczdhOioi+X3kRLspOP22nPcUGEzf/BcTd2Wab9vPr2
         Pb+N0BxHyJH2UG61ugOuyC7ND/2XO7a1AAvBqSddPCtxvGkFlyUweO+GxukeWHRkQLyG
         GSzOxEhS5UmBsZtvXcWaPYZyMCdtpdX+51/lZH7B3YGIrlj1f6rRpOARqnvUSkOJO7lm
         aX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hl19yC27qvJPGzvVoFgwuG8P3RA3WT4VWzdG/9QIu5c=;
        b=rf35cl/icSz8RACWLuwSlxSbtJ8o9MhKSCrZQZPMAkyBx/tD+3Z7sP+8lnusIC38C4
         lutGgHNJ/Yj5o8l4LrjaPKXXnky/BP60O0Q+uApOOvO19XQI1yWFnipBeUl229H3afT0
         CeEfZUmmiQqTK3u9Hi/knGBuImGPBNKJH6tNx0z4JvaG9ErDjH2jHiI9j70JIvIsO0tI
         wc/3XCNRkxERAg14SJb1ZNIjJGSNXWe4RMgUpU8oCduZc3PiCAvlDkg94+FVYof6TFOj
         53BQM2D5MO3iARwHghg7v5aMM5+oRUVeg2Nofc4xzJIzxyVCFlxTQ9MSngytfwyp7tRO
         4DEw==
X-Gm-Message-State: ACgBeo1tbX+YtxbkJc5iIc/GrysXJayUjvUGEd2Z1IA2SM94eUyDE6Ah
        CBGIAUuDumpovalB3nTiZEhL9RSBaKTVXw==
X-Google-Smtp-Source: AA6agR7OFBttzwRQAP0jnnmDnPAv1l0tyFU2JXitdpeRVfDA4S77kutEDWZof5n4mxHqPaLyKs4WNQ==
X-Received: by 2002:a17:90b:2404:b0:1fc:b5d1:446f with SMTP id nr4-20020a17090b240400b001fcb5d1446fmr18494415pjb.58.1661785392095;
        Mon, 29 Aug 2022 08:03:12 -0700 (PDT)
Received: from Negi ([207.151.52.7])
        by smtp.gmail.com with ESMTPSA id u1-20020a170902e80100b0016c4546fbf9sm6644546plg.128.2022.08.29.08.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 08:03:11 -0700 (PDT)
Date:   Mon, 29 Aug 2022 08:03:10 -0700
From:   Soumya Negi <soumya.negi97@gmail.com>
To:     Anton Altaparmakov <anton@tuxera.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ntfs: Ensure $Extend is a directory
Message-ID: <20220829150309.GA26122@Negi>
References: <20220727001513.11902-1-soumya.negi97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727001513.11902-1-soumya.negi97@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 05:15:13PM -0700, Soumya Negi wrote:
> Fix Syzbot bug: kernel BUG in ntfs_lookup_inode_by_name
> https://syzkaller.appspot.com/bug?id=32cf53b48c1846ffc25a185a2e92e170d1a95d71
> 
> Check whether $Extend is a directory or not( for NTFS3.0+) while
> loading system files. If it isn't(as in the case of this bug where the
> mft record for $Extend contains a regular file), load_system_files()
> returns false.
> 
> Reported-by: syzbot+30b7f850c6d98ea461d2@syzkaller.appspotmail.com
> CC: stable@vger.kernel.org # 4.9+
> Signed-off-by: Soumya Negi <soumya.negi97@gmail.com>
> ---
> Changes since v1:
> * Added CC tag for stable
> * Formatted changelog to fit within 72 cols
> 
> ---
>  fs/ntfs/super.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 5ae8de09b271..18e2902531f9 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -2092,10 +2092,15 @@ static bool load_system_files(ntfs_volume *vol)
>  	// TODO: Initialize security.
>  	/* Get the extended system files' directory inode. */
>  	vol->extend_ino = ntfs_iget(sb, FILE_Extend);
> -	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino)) {
> +	if (IS_ERR(vol->extend_ino) || is_bad_inode(vol->extend_ino) ||
> +	    !S_ISDIR(vol->extend_ino->i_mode)) {
> +		static const char *es1 = "$Extend is not a directory";
> +		static const char *es2 = "Failed to load $Extend";
> +		const char *es = !S_ISDIR(vol->extend_ino->i_mode) ? es1 : es2;
> +
>  		if (!IS_ERR(vol->extend_ino))
>  			iput(vol->extend_ino);
> -		ntfs_error(sb, "Failed to load $Extend.");
> +		ntfs_error(sb, "%s.", es);
>  		goto iput_sec_err_out;
>  	}
>  #ifdef NTFS_RW
> -- 
> 2.17.1

Hi Anton,
Have you had a chance to look at this patch?

Thanks,
Soumya

