Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8316B2149
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 11:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCIKWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 05:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjCIKWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 05:22:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B995BD9E;
        Thu,  9 Mar 2023 02:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC73F61ADD;
        Thu,  9 Mar 2023 10:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC005C433D2;
        Thu,  9 Mar 2023 10:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678357330;
        bh=evv28xiKYzjwZQ9COm/b53ivkKvoKDN2Zn8yRRg/VWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HEhvdGGi+dWBjEpCtFVVFxxl8fxfFQ1SOHRlu8UV0P5watjNgKqf2NpL+g2TUmUxS
         rP6KKigKohBYp7GHVt8TqQYJdFpsKqAYU8T/Vua8zpE5X9WLaUS+/AaC/LwlW2N4ah
         CYHnNsrr6sTUtXhjY3RPjXIKPt2ojbUFceKemTo4=
Date:   Thu, 9 Mar 2023 11:22:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sylvain Menu <sylvain.menu@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        chuck.lever@oracle.com, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: nfs mount disappears due to inode revalidate failure
Message-ID: <ZAmzT/D8YxJ3844j@kroah.com>
References: <CACH9xG8-tEtWstUVmD9eZFEEAqx-E8Gs14wDL+=uNtBK=-KJvQ@mail.gmail.com>
 <ZAmv57xeNqs7v9hY@kroah.com>
 <CACH9xG9=BFszD9OXspttTFdki0e68b5Hw7o11AUQ7pptSMy9wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACH9xG9=BFszD9OXspttTFdki0e68b5Hw7o11AUQ7pptSMy9wQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 09, 2023 at 11:17:30AM +0100, Sylvain Menu wrote:
> I think it's a regression according to the old resolved bugs/tickets
> but no idea since when it's broken again

Any chance you can do 'git bisect' to find where it broke and what
commit broke it?

thanks,

greg k-h
