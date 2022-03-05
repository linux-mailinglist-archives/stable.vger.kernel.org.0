Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEEA4CE333
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 06:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiCEFxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 00:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCEFx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 00:53:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7453014F99C;
        Fri,  4 Mar 2022 21:52:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FFAE60A69;
        Sat,  5 Mar 2022 05:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6B4C004E1;
        Sat,  5 Mar 2022 05:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646459558;
        bh=TmX5r4HLh5PvrrD8E4B032rd4bRI0/BSVKu04zx6gRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R53ud9Y7CmHi7fMzJHtJQtOZIV3Nwu780KGZF3vDfW27RC1Cj89XES2t7FVjmmD6W
         1z6kbr9oEwj/Z0vQduwUb/jxUfQ6cL+XhDdc9mHT05xeS96Eg5z63cn3dlafmc9se4
         pxQm0xKDXrCbs952Nlou4LOV1E1tDEUpc2QW7OV2KVI3Bg/r40saTTN6/1HQ6Zpi/W
         y/MEChzdL6bWaibSI3og1DXKkUogdnMCPt6gzEtplelnDxIxc4diq7K23miFBBGYcz
         0P7Jjnaxyo1QVNPCbW0XKm7IwCEHCXOcpnu5DUZvPviqdpS+wM7yaWh1oyZGZOP7dg
         PyPQjdIsKO9+g==
Date:   Sat, 5 Mar 2022 07:51:52 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: asymmetric: enforce that sig algo matches key
 algo
Message-ID: <YiL6ePrlN8OhsKEW@iki.fi>
References: <20220201003414.55380-1-ebiggers@kernel.org>
 <20220201003414.55380-2-ebiggers@kernel.org>
 <YhLuOeIKLwlucpKv@kernel.org>
 <YiJn0lJxoUMUJ6wP@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiJn0lJxoUMUJ6wP@sol.localdomain>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 11:26:10AM -0800, Eric Biggers wrote:
> On Mon, Feb 21, 2022 at 02:43:21AM +0100, Jarkko Sakkinen wrote:
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > David, do you want to pick this?
> > 
> 
> No response from David, so I think you need to take these.
> 
> - Eric

I did, they're applied now, thank you.

BR, Jarkko
