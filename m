Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727174EC955
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348617AbiC3QKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348633AbiC3QKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:10:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FCA1E747D;
        Wed, 30 Mar 2022 09:08:20 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 71FF768AA6; Wed, 30 Mar 2022 18:08:16 +0200 (CEST)
Date:   Wed, 30 Mar 2022 18:08:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 02/19] exportfs: support idmapped mounts
Message-ID: <20220330160816.GA5633@lst.de>
References: <20220330102409.1290850-1-brauner@kernel.org> <20220330102409.1290850-3-brauner@kernel.org> <20220330152635.GB4835@lst.de> <20220330160448.bugfza2akk3zsici@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330160448.bugfza2akk3zsici@wittgenstein>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 06:04:48PM +0200, Christian Brauner wrote:
> > This probably wants a Fixes tag, as without it NFS exporting idmapped
> > file will give slightly unexpected results.
> 
> I made it so that the nfs kernel server will refuse to be mounted on top
> of idmapped mounts in check_export() similar to what I did originally do
> for overlayfs. It's unclear what the Fixes: tag would be so I'll just Cc
> stable.

So knfsd is fine, and the handle_to_name syscall doesn't ever do the
equivalent of the subtree check.  So with that we probably don't need
a Fixes tag - sorry for the noise.
