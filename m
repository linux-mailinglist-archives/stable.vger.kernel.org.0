Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE06D1F4C
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 13:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCaLkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 07:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjCaLjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 07:39:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07191D872
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 04:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C143E62845
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 11:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3C6C4339B;
        Fri, 31 Mar 2023 11:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680262775;
        bh=3EhB2PFpFyjZt5zg+eQXbNuoXzFQfoUqtMWAuLOj42I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EEiyqjLpVWM4H5vAAGjQTKMrRQukqxpsBlh9M33AVfRzKmlaqTRSvKjuoP2FTc2Tu
         6B3hmKxcMKxBLLOlF4tLGNwZ3td36Jl+MYwsi33P7CL0Hdrl3IKqd5dPYHZE52zebg
         R0PQdtbn/kGiLd3UtfIzqe51uGrGYejMXra+tLIkTMw5mMFlXKlHljdPZr2snc0uoK
         TOOt38yQflUNL6HRnbhFC82QvMznxYrN5S/kzKm8+uq/Nj8DGDNLt6oXrIoDoN765I
         SVgsjfCLS5sS3AL5W9Jd4+7YSV0mWyT4vTPsaPSEvckbXBSo5vhE4LMzvQ0aJW0fFf
         IQEiHIeg9O3Bw==
Date:   Fri, 31 Mar 2023 07:39:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nobel Barakat <nobelbarakat@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: 6.1 Backport Request: act_mirred: use the backlog for nested
 calls to mirred ingress
Message-ID: <ZCbGdXSqEO1NlpxG@sashalap>
References: <CANZXNgPN=yNchM00fn0-7nd5xs_6DEgTFng0zS96J+tGnntynQ@mail.gmail.com>
 <ZCK8Voa2AWbCUHo6@sashalap>
 <CANZXNgNgYvsdD6y3QETRG-XM4ShiNGOrz9AmvnzNRL3uuLvGJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANZXNgNgYvsdD6y3QETRG-XM4ShiNGOrz9AmvnzNRL3uuLvGJQ@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 03:04:56PM -0700, Nobel Barakat wrote:
>Hey sorry, looks like
>act_mirred-use-the-backlog-for-nested-calls-to-mirre.patch isn't
>compiling correctly on 6.1. It probably should be removed. Same goes
>for 5.15 and 5.10, looks like those two are running into compilation
>errors on our config.

I've tried the provided 6.1 config, and it seems to compile just fine
for me. What errors are you seeing?

-- 
Thanks,
Sasha
