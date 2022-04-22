Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BE350B6FC
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447354AbiDVMMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 08:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447330AbiDVMMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 08:12:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7201456740
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 05:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01E1E61FC6
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 12:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C25C385A4;
        Fri, 22 Apr 2022 12:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650629346;
        bh=RlGEzQWlv09H/8VczInDN3EsUWHgLBoy5YbbTyjH5NY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dI+q0IblNr3RL470m5e0TdZ5zKduOGSnqQZDozKNvck2G7DXOQCBG3cKl5nxpcAR5
         aVyDx59/barlirpBeaaoSDdTSEfgTK83yvLhZmbopvwfDlFZG0nCFkHbpk3kK3r1cQ
         nrUk4pa8DJWu/FX3qi2DVJTTQSP7sb3kugYy4l6Y=
Date:   Fri, 22 Apr 2022 14:09:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joshua Freedman <freedman.joshua@gmail.com>
Cc:     lis8215@gmail.com, paul@crapouillou.net, stable@vger.kernel.org,
        sboyd@kernel.org
Subject: Re: kernel 5.16.12 and above broke yoga c930 sound and mic
Message-ID: <YmKa3RGRdHTYRRZB@kroah.com>
References: <YkQUGVC3MBSnc2LI@kroah.com>
 <CAJQ3t4TqK+q5zeHCQ2uxGvhT4q0Bpe6PBuDTm28HqyHwH5mzhQ@mail.gmail.com>
 <YkQnGmxdi9GWZmfC@kroah.com>
 <CAJQ3t4SnNyHEaWizzVDbaMSdHDRe9wHGx2RdgJJea=G4sFmdnw@mail.gmail.com>
 <YkQ44cqrnIH6aoxg@kroah.com>
 <CAJQ3t4Rg2WhDoynG=NmHX5dgt3u5BB3gfpAbskb4gQ_R8qxmxA@mail.gmail.com>
 <YkbYMBpNztYHUsD2@kroah.com>
 <CAJQ3t4Q3ToQ9_Y3qc2WTsgxD9D14F-x4X5gTDB-mEWXqbeCk=g@mail.gmail.com>
 <YlP28bAQQB646UXi@kroah.com>
 <CAJQ3t4Sf3fLqxrpwvmZ9KCgfXVTdaxaUcG1U_gEK+xDo3+BHxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJQ3t4Sf3fLqxrpwvmZ9KCgfXVTdaxaUcG1U_gEK+xDo3+BHxQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 22, 2022 at 07:09:34AM -0400, Joshua Freedman wrote:
> The kernel I was using as good for audio is now missing; It was
> 5.16.11-76051611-generic But the only release avail now is
> 5.16.11-051611-generic and  audio does not work.

Those look like distro-specific kernels, please contact your distro for
support of this, there is nothing we can do here about them.

good luck!

greg k-h
