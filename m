Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF051D4D0
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbiEFJoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390707AbiEFJo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:44:29 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA045140CC;
        Fri,  6 May 2022 02:40:45 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B9A263200AC4;
        Fri,  6 May 2022 05:40:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 06 May 2022 05:40:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1651830043; x=1651916443; bh=MnXUONzLP/
        KGclCY+1LYfcxNnDi042TfsCcfwTXLgqU=; b=jgrcpdiD9IjHrphjGuAPUcSvjv
        QmPn4DH/TNP0ZG2lyzGw0d4KDayYASKr2mmf1rTdTAl3LrGykuK76dtCn8uESdps
        phPC+IMAToTQ+6nN8uniKC840aDL++YlVxeWZerjDN0EhSJbmkUi02fwRY8q6pX4
        BWdzqnnP9O1cQBOEUbwOWZBGyrE68UHx96bc+MsbfdSF//RpXn/5N7ldjdXA6maa
        6DTXp1z/lKpk//dFX8aj50MTVNexFBhIdkpyP6pRzN+df1yGZWrCy0fx1deOkQP0
        56nm3EIaJp6GrWDQpHq4T4AgX4GkAwd4GmemXoiXkkpZfIDhUBPn7O9S3s3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651830043; x=
        1651916443; bh=MnXUONzLP/KGclCY+1LYfcxNnDi042TfsCcfwTXLgqU=; b=g
        q3DI65ontVYJ80dqoA4y07oiifYM68FUiZvyUb6jLNYihnz7JRR7tKaEdrufoDAj
        sIuYlzvTF517+rREiuAagZZC0XaWwftOJ1hH9dCc9VwHsWVC5dEUXLUV0yEdxo9d
        PNTbYPmWdocVhzrqATqkw4s+H5G5/VCPQgtApALX3r15Ox1RNI85KShl6QcJG5+G
        mVxVGyRWQfdNrc6+fQcmN7pfYUL1NmYSE3FTOeg6ajE48MWOLOwmUnRAkHOceMGM
        H87R4UwdKSGAVlkb508FvSoALGuI6ehuvNydURz/NLl3tfDr24mA22qyeeK0aqxi
        viSrLOtxAwjUNh/CnD7lA==
X-ME-Sender: <xms:G-10YoAyiy0zZGVrY8dJMlU3DUs8IUvu9OQgdKnycsSbKSxXSIrgng>
    <xme:G-10YqicmUkr18W-ClTabmcbuI07vyJJmRcz6noqs8LlyFeeJ4bW9spn12SZqfh_W
    Nr9SLhvoXhmvA>
X-ME-Received: <xmr:G-10Yrn7Zms4c27xYgm_wBhD2CDFY09agVoSWKyie-umio4inFlI6orEVS9H>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeefgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:G-10YuzPcAJR4WDwKgUe-md7VVi1VAo5N3NwqYSOxwdaFGgehSeySA>
    <xmx:G-10YtRTqvb6UvwiwqlZpvPr8x8XdxgU0itnCEjS030rHstPJ-C1vA>
    <xmx:G-10YpbFLK489fBQySVHlhcctxkXaYn6mMzRPbSL46T6U148mb276w>
    <xmx:G-10YsLXAK_kmTbJWrdzf4YJJiZ8ZojJsWnujgI2KHefivGJIdWZlA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 May 2022 05:40:42 -0400 (EDT)
Date:   Fri, 6 May 2022 11:40:39 +0200
From:   Greg KH <greg@kroah.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: Re: [PATCH 02/12] crypto: qat - refactor submission logic
Message-ID: <YnTtF82pxBMGje9f@kroah.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-3-giovanni.cabiddu@intel.com>
 <YnTpPoN9JZqjqvsG@kroah.com>
 <YnTsikYX23hfQDZt@silpixa00400314>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTsikYX23hfQDZt@silpixa00400314>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 10:38:18AM +0100, Giovanni Cabiddu wrote:
> On Fri, May 06, 2022 at 11:24:14AM +0200, Greg KH wrote:
> > On Fri, May 06, 2022 at 09:23:17AM +0100, Giovanni Cabiddu wrote:
> > > Move the submission loop to a new function, qat_alg_send_message(), and
> > > share it between the symmetric and the asymmetric algorithms.
> > > 
> > > If the HW queues are full return -ENOSPC instead of -EBUSY.
> > > 
> > > For both symmetric and asymmetric services set the number of retries
> > > before returning an error to a value that works for both, 20 (was 10 for
> > > symmetric and 100 for asymmetric).
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > > Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
> > 
> > What does this "fix" to require it to be backported to stable trees?
> For two reasons, (1) the error code returned if the HW queues are full is
> incorrect and (2) to facilitate the backport of the next fix "crypto:
> qat - add backlog mechanism".
> I can be more explicit in the commit message if required.

Please always be explicit in the commit message, it's the only way to
communicate this type of thing.

thanks,

greg k-h
