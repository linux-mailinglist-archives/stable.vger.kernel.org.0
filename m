Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7D1500B35
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241192AbiDNKft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242367AbiDNKfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:35:45 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2C078052
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:33:13 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8FA713200657;
        Thu, 14 Apr 2022 06:33:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 14 Apr 2022 06:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1649932390; x=1650018790; bh=kj035TXx/p
        NquxLDwkEJ/BLj1e8A15CLJTqtKhX9wL4=; b=VY07FJDz9xqqXAewFBSsGMRJYs
        evDzKwBI8eZGjRqmOLV3T278LQupkaB2LJZxNNxE+/m1YjzTib+wM6wb1p+oNWg6
        dLLcIpOFHVPvMzhl3E2xs/PT8F6MvPYa0lG+7+a2Y2uluPYs0acu1/QeNI89oFy4
        tNY0ZJLfgMsh3h2sV9at0Vvu+bI0379/+g/3R5y+L3/uWirJxWq2PTmVzIEtxjvi
        VsDQ/yv8x7Cx2/GmvroGB/ba3FlscKxfmKjecZt8ES/IDfSYKObL4UvHUykKKOTO
        mod44Bjo1zdfI67IrLIZHdvGTnc8jWZn2cX/WJl5VCcGvVe3rFn+v6AyRTgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1649932390; x=
        1650018790; bh=kj035TXx/pNquxLDwkEJ/BLj1e8A15CLJTqtKhX9wL4=; b=S
        3K0zPF54cQq0ts/VQ9nG7AHnLCL6+7LVuboG39CjN5wJF/sd3hsvqUMRrF73eYx4
        SihcU6rjkigwuN7BV3n0l9hRgncL+/1thS1uyclnCrlrikbDpMBh9wfuDipziu4b
        qP6FANzBdWchBYDQ0wivljL2ScUMbMZeloS03QNe6ZpsO+MajmTFgdQI6bMvCNf2
        QVKTfut3GOFUgZ7ieDp+h0in+A46ksFUzMhCy/EKd4JXqh6xW4fauJjgg1SyI7a9
        9BEAToRMHX2bYuw8l/obFdud9L5YcMF29JFe3jSBALqNXbbrIEFc8OVS7xfZJpkV
        MAfFd1+mXtBAY259SFY5g==
X-ME-Sender: <xms:ZfhXYjWFJTRXuEXCD7yFKtoWVyGletZszX19_DLdoLpcXgnlbT6AoA>
    <xme:ZfhXYrlxefQZHDvEzW3JR6QbVtxtS1XcYxR703jVMNo9Qvd3XF6vdnWSOO4P_zzPH
    4pnbnRc6oVxRw>
X-ME-Received: <xmr:ZfhXYvb5zW97dseRsunuM038MWjrGEgIBl_bav-xcQS92WJymvs_MTjY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudelfedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZfhXYuXd8bDDVTc8YecXeAG1cXgpgdivhJOl_KgXwuMl2wJJwPyRxQ>
    <xmx:ZfhXYtn8tgXHUQw8ZmwYys49yZaWn76tefOQAabiu9YOKuOHAmTf4w>
    <xmx:ZfhXYrc6B504yIPB7GVGEfQJTXvvI6wzwiLXDapqitcdlFh2S5F5HQ>
    <xmx:ZvhXYrahAnAprv6VZ5_IfQ6et8M5S2QT9hY3K4C29xx6e6UondqaiA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Apr 2022 06:33:09 -0400 (EDT)
Date:   Thu, 14 Apr 2022 12:32:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, tj@kernel.org, mkoutny@suse.com
Subject: Re: [PATCH 5.4 0/6] cgroup: backports for CVE-2021-4197
Message-ID: <Ylf4WEClP0O9nRLm@kroah.com>
References: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 11:44:44AM +0300, Ovidiu Panait wrote:
> Backport summary
> ----------------
> 1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
> 	* Cherry pick from 5.10-stable with minor contextual adjustments.
> 
> 0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
> 	* Cherry-pick from 5.10-stable, no modifications.
> 
> e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
> 	* Cherry-pick from 5.10-stable.
> 	* Backport to 5.4: drop changes to cgroup_attach_permissions() and
> 	  cgroup_css_set_fork() as the two functions are not present. Also,
> 	  adjust cgroup_procs_write_permission() callsites directly in
> 	  cgroup_procs_write() and cgroup_threads_write().
> 
> b09c2baa5634 ("selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644")
> 	* Clean cherry-pick.
> 
> 613e040e4dc2 ("selftests: cgroup: Test open-time credential usage for migration checks")
> 	* Minor contextual adjustments.
> 
> bf35a7879f1d ("selftests: cgroup: Test open-time cgroup namespace usage for migration checks")
> 	* Minor contextual adjustments and added wait.h
> 	  and fcntl.h includes to fix compilation.

All now queued up, thanks!


greg k-h
