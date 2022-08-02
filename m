Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75941587D10
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 15:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiHBN1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 09:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbiHBN1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 09:27:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF70616599;
        Tue,  2 Aug 2022 06:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B0EDCE1F97;
        Tue,  2 Aug 2022 13:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270A8C433C1;
        Tue,  2 Aug 2022 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659446830;
        bh=oGuRlrXI6FXr5L+WyHeoq2/EjOd+atoXtE088df664k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=utENAUjwnL7+I49visiv1K7d3+ftb41L6vTl00elKyO7FaJkAONt3iFGn3bwKns7g
         NhSCvYTgy5/D8HjPh7SCzK8OqVx5sI+FeWw05svBhxum19pV56K0w1kOmZH5sE/Tai
         OU5OED7d+WJj9WA9Gl3qEFaXMTgkZNSC6WO41iFc=
Date:   Tue, 2 Aug 2022 15:27:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: Re: [PATCH 5.10 63/65] bpf: Consolidate shared test timing code
Message-ID: <YukmK5Fd1FblO3IJ@kroah.com>
References: <20220801114133.641770326@linuxfoundation.org>
 <20220801114136.261188102@linuxfoundation.org>
 <20220802121348.GA23779@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802121348.GA23779@duo.ucw.cz>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 02, 2022 at 02:13:48PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Tianchen Ding <dtcccc@linux.alibaba.com>
> > 
> > From: Lorenz Bauer <lmb@cloudflare.com>
> > 
> > commit 607b9cc92bd7208338d714a22b8082fe83bcb177 upstream.
> 
> Patches 63 to 65 have double "From" and thus mismatching sign-off.

Ick, sorry, now fixed up.

greg k-h
