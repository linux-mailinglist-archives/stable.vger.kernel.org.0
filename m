Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206C65A86C0
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 21:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiHaTba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 15:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiHaTb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 15:31:29 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1C51B78C;
        Wed, 31 Aug 2022 12:31:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id e18so12191628edj.3;
        Wed, 31 Aug 2022 12:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=4+6po5GYFfTX8paYVdDOE5q2kbTcwArx1zGTGXO7xbI=;
        b=qBc30pTgCg4y/jgGdj7Xa8WdP1E5cM1zNxVp83X1cVq0nIuL8Mt0l4L+mYfgp79e1f
         X6zDR228cO8XToTClHuFpQRj02fxJ4DuLmEfLPm5PelnSm3090hZ8p6o4XiVdsE41VGH
         ZNSdNTNNmih2uTVc9tLBuL2XA8BOMjTEoxctFiepzen6VbS3HGBKE6NwV6sNC2Z1XS/9
         YnpNPEb1doacXArVNB+PM7NkZOG1tnXdU4iaJcePfV2np95ixYioJp2CK0ZhIWu06dGF
         XLoHmBUb4se8aBJLYzOdYSyjwArpefGXA9GKuNJjIhYGexfwYXOzteK6vNeZa/4VlNGT
         mLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4+6po5GYFfTX8paYVdDOE5q2kbTcwArx1zGTGXO7xbI=;
        b=vw/31GW1D03POZcvLXEQiBrXzfIGGZkt/qLdhtcRE/dE3/WNBHhfZgsG7bC/4DqwWs
         2uKbHSvzsQY7DkECKm7XaVrXe/e6EUig+bzRwQMwLG/AvKbIQnglH2dXhV5BlgsISzCj
         8LX6u6BzIywgRM2jTg15+PG8RJyBk7egv3mNC3W0WnmYoOErSLUaB/XAAYXUI1USC483
         LPYCrVaPCZh9+uU+uIKWqC9mdm1QlAC6MbyPEGijkRFhR+9K1192DqT4mYQnSPlLN8YK
         c3fn4kBeqbjARJFVMAA65mW+9C6b+su30wc2VFhldU16QlRMAt38cRJaTBpY2pR4+VFK
         7yog==
X-Gm-Message-State: ACgBeo207Trl+YKi+r4QreNYru9DVWQ45ypbG4LDXpgMRkRxFGZISW9M
        RK/SGFWziHkKxTPttYTVeCk=
X-Google-Smtp-Source: AA6agR4DtrQYW+uocP/vQY5CUrYLyGGXzFUGm48fj6AjlYFWzFOHZxIkela9tzbMy4waw/IFsfV9vg==
X-Received: by 2002:a05:6402:84e:b0:440:4bac:be5a with SMTP id b14-20020a056402084e00b004404bacbe5amr26462222edz.103.1661974285658;
        Wed, 31 Aug 2022 12:31:25 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id et17-20020a170907295100b0073093eaf53esm7485575ejc.131.2022.08.31.12.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 12:31:22 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 6E2D2BE41F1; Wed, 31 Aug 2022 21:31:21 +0200 (CEST)
Date:   Wed, 31 Aug 2022 21:31:21 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix check for block being out of directory size
Message-ID: <Yw+3CfOL6YtYKHZl@eldamar.lan>
References: <20220822114832.1482-1-jack@suse.cz>
 <20220823100019.wukhx7a6bul4isjl@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823100019.wukhx7a6bul4isjl@fedora>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Aug 23, 2022 at 12:00:19PM +0200, Lukas Czerner wrote:
> On Mon, Aug 22, 2022 at 01:48:32PM +0200, Jan Kara wrote:
> > The check in __ext4_read_dirblock() for block being outside of directory
> > size was wrong because it compared block number against directory size
> > in bytes. Fix it.
> 
> Good catch, thanks!
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
> > 
> > Fixes: 65f8ea4cd57d ("ext4: check if directory block is within i_size")
> > CVE: CVE-2022-1184
> > CC: stable@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/namei.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 3a31b662f661..bc2e0612ec32 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -126,7 +126,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
> >  	struct ext4_dir_entry *dirent;
> >  	int is_dx_block = 0;
> >  
> > -	if (block >= inode->i_size) {
> > +	if (block >= inode->i_size >> inode->i_blkbits) {
> >  		ext4_error_inode(inode, func, line, block,
> >  		       "Attempting to read directory block (%u) that is past i_size (%llu)",
> >  		       block, inode->i_size);

Ted, is this on your radar to get applied for mainline and to the
stable trees?

Regards,
Salvatore
