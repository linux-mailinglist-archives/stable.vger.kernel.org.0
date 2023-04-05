Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C46D6D7F31
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbjDEOVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237503AbjDEOVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:21:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397035FFA
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 07:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1675F62755
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 14:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0749BC433EF;
        Wed,  5 Apr 2023 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680704448;
        bh=btbPux0eFWafe1NQLw2ZxhsMN4Gxi4p1nV2A1irZIWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fXj05RZKA4ticFCf9iuC2+ylwEUjnpDLTFqw1ROzk7rcNAdf4BfI19YVCBW6NMp69
         Rl7Icocj0G+C6niGphO4RBiVCJ5WC3lPXVCrNZAYj5tYRrAovUcNP5gBK9ccmCj+7/
         cVLUoKT2t0Ghgs79Bq8i2AI+3QdBVlBk/9Qz73dA=
Date:   Wed, 5 Apr 2023 16:20:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pratyush Yadav <ptyadav@amazon.de>
Cc:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4] smb3: fix problem with null cifs super block with
 previous patch
Message-ID: <2023040523-delusion-corrode-f466@gregkh>
References: <20230405135709.100174-1-ptyadav@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405135709.100174-1-ptyadav@amazon.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 03:57:09PM +0200, Pratyush Yadav wrote:
> From: Steve French <stfrench@microsoft.com>
> 
> [ Upstream commit 87f93d82e0952da18af4d978e7d887b4c5326c0b ]
> 
> Add check for null cifs_sb to create_options helper
> 
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> ---
> 
> Only compile-tested. This was discovered by our static code analysis
> tool. I do not use CIFS and do not know how to actually reproduce the
> NULL dereference.
> 
> Follow up from [0]. Original patch is at [1].
> 
> Mandatory text due to licensing terms:
> 
> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.

What?  That's funny.  And nothing I'm going to be adding to the
changelog text, sorry, as that's not what is upstream.  Please go poke
your lawyers, that's not ok.

thanks,

greg k-h
