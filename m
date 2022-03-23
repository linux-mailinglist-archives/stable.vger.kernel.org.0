Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95524E52EC
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiCWNWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 09:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiCWNWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 09:22:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A901C3EB8E
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 06:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE351615F8
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 13:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC9BC340E8;
        Wed, 23 Mar 2022 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648041645;
        bh=5Tw9uXRqBxVfwkfG05xsb15zXOablL75+ehvO/v4F3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dr7wtFBlmIS6RlqkV8iG55MkoOvwHlWCrO1crMq8mcYLSztRVBbzNJQvf0qegOCE6
         J6ax0t2H9LM18rS8LHmABxpMiN2P5s0lZH3iC1uK/6D4Bs5MbVbaGc3AxJG/tkOgOE
         m7Og8gxiwq3evkkJ+KXxFZ/hVlVVl/cH0geMHTEM=
Date:   Wed, 23 Mar 2022 14:20:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     masami.ichikawa@cybertrust.co.jp, tj@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] cgroup-v1: Correct privileges check in
 release_agent writes" failed to apply to 5.10-stable tree
Message-ID: <YjseqrSJQd9412So@kroah.com>
References: <1645639632780@kroah.com>
 <20220323124932.GA27232@blackbody.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220323124932.GA27232@blackbody.suse.cz>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 23, 2022 at 01:49:32PM +0100, Michal Koutný wrote:
> Hello.
> 
> On Wed, Feb 23, 2022 at 07:07:12PM +0100, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.10-stable tree.
> 
> What do you mean does not apply?
> 
> > HEAD is now at 9940314ebfc6 Linux 5.10.108
> > $ git format-patch -o /tmp/ 467a726b754f474936980da793b4ff2ec3e382a7 -1
> > /tmp/0001-cgroup-v1-Correct-privileges-check-in-release_agent-.patch
> > $ git am /tmp/0001-cgroup-v1-Correct-privileges-check-in-release_agent-.patch
> > Applying: cgroup-v1: Correct privileges check in release_agent writes
> > $

Sorry, yes, it applies, but it breaks the build.  Try typing 'make' now :)
