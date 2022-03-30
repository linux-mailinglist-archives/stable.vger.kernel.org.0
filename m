Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B309D4EC9CA
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbiC3Qjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346850AbiC3Qjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:39:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42902197AE8
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2048617DB
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 16:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF039C340EC;
        Wed, 30 Mar 2022 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648658265;
        bh=+5U6Ul2N4rMX8s90FZcPGySACOdPEMUESOl5beqzbxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2my7hzpImqjbZiV5Rh6fHlYvGRO4A/M0aZ+MV7SuButPeON00OTxmTywi/tY/F3+5
         aDCjGAVJHR6clHKqFHypqavKqK3RG7pf/HjNZDfp2xria2QZnufaOT7bDFymmQWK9m
         O4AFf0lBoJS0nW9El1OiBX/e78m3spMAHn4RzHNk=
Date:   Wed, 30 Mar 2022 18:37:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
Message-ID: <YkSHViipbwCb6sZQ@kroah.com>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329220256.72283-2-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
> Please apply this to stable 5.10.y, and 5.15.y
> ---8<---
> 
> From: Kees Cook <keescook@chromium.org>
> 
> Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")

What about 5.16?

