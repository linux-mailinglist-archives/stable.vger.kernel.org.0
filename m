Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5AD6B8837
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 03:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjCNCRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 22:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCNCRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 22:17:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810F474DF3;
        Mon, 13 Mar 2023 19:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D30D61568;
        Tue, 14 Mar 2023 02:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BE4C433EF;
        Tue, 14 Mar 2023 02:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678760221;
        bh=UtMc2HIRW2sA6QVojclDoqMIDC0pR/NtSuo5jT/W5RQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I56P5kEladRF1DyG9KSRoi3ET602Ygnwtk8p5HxSotXuN/YMXyfaOh6zPHNn+qjo1
         gbJc+AxoLaAkxZsCt/b3HWpZDuvk75elNBbAuT0xiGEmeDbG65pKCH1rUFRcO7f+Kq
         A9SVwy4t+D27Je4QQfePB1ZO9QADSbsNbnfagamOGWR5tXPHhs846VeYjluegcleIm
         QM5wBJ8wzaTrVItJe0mGIJqhGrV378iVj3xulvK4zBFo+H1gWf5e+2/qOARq0Yi8B7
         LCNl+4Er5y1YdO909+X9NoIiX8FOzPGcxdqD4XaT2JnxOkpqAVs90wKQMvJNhGsgE4
         M99zJ+VLaE2ZA==
Date:   Mon, 13 Mar 2023 22:16:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, chandan.babu@oracle.com
Subject: Re: [PATCH 5.15 00/11] sgid fixes for 5.15.y
Message-ID: <ZA/ZGzTO5BPKs9Rc@sashalap>
References: <20230307185922.125907-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230307185922.125907-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 10:59:11AM -0800, Leah Rumancik wrote:
>Hello,
>
>I finished testing the sgid fixes which Amir graciously backported to
>5.15. This series fixes the previously failing generic/673 and
>generic/68[3-7]. No regressions were seen in the 25 runs of the auto
>group x 8 configs. I also did some extra runs on the perms group and
>no regressions there either. The corresponding fixes are already in
>6.1.y.

Queued up, thanks!

-- 
Thanks,
Sasha
