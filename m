Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5064FB7CB
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbiDKJkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344642AbiDKJkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:40:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340C3403F4
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8203B81122
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED95C385A3;
        Mon, 11 Apr 2022 09:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649669876;
        bh=aVV0dv0wMJKpJJpfIvWg1B8jC8m1PNw8VJhhL7Tod/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MzKFdeXoljtQhkqg0EwrRHEh9mOgGHT3QlbJAgUiLwvPxueyvpaD0IIVYse1JhSZK
         Y7E/Z8v+ksmAHXI3W3CsirvYqWD9qY/yClyfXd8yqrCwmG3pWcjg3P++e5I6+Lesn6
         0IKdcGInoYIqVeFny6d75NmbhwE1sM5d+xP0Jz5w=
Date:   Mon, 11 Apr 2022 11:37:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joshua Freedman <freedman.joshua@gmail.com>
Cc:     lis8215@gmail.com, paul@crapouillou.net, stable@vger.kernel.org,
        sboyd@kernel.org
Subject: Re: kernel 5.16.12 and above broke yoga c930 sound and mic
Message-ID: <YlP28bAQQB646UXi@kroah.com>
References: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
 <YkQUGVC3MBSnc2LI@kroah.com>
 <CAJQ3t4TqK+q5zeHCQ2uxGvhT4q0Bpe6PBuDTm28HqyHwH5mzhQ@mail.gmail.com>
 <YkQnGmxdi9GWZmfC@kroah.com>
 <CAJQ3t4SnNyHEaWizzVDbaMSdHDRe9wHGx2RdgJJea=G4sFmdnw@mail.gmail.com>
 <YkQ44cqrnIH6aoxg@kroah.com>
 <CAJQ3t4Rg2WhDoynG=NmHX5dgt3u5BB3gfpAbskb4gQ_R8qxmxA@mail.gmail.com>
 <YkbYMBpNztYHUsD2@kroah.com>
 <CAJQ3t4Q3ToQ9_Y3qc2WTsgxD9D14F-x4X5gTDB-mEWXqbeCk=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJQ3t4Q3ToQ9_Y3qc2WTsgxD9D14F-x4X5gTDB-mEWXqbeCk=g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 08, 2022 at 07:53:42PM -0400, Joshua Freedman wrote:
> I got the first bisect done, but not sure what do bisect after that.....

What is the result, good or bad?  What does 'git bisect log' show?

thanks,

greg k-h
