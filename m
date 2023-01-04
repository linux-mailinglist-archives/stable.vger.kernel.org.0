Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4BA65D2E3
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbjADMiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239296AbjADMiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:38:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797EB37391;
        Wed,  4 Jan 2023 04:38:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF724B81629;
        Wed,  4 Jan 2023 12:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF75C433D2;
        Wed,  4 Jan 2023 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672835887;
        bh=mZ1yQV6qgagBCn4KzMBLklPWpB3lKrVvtA6CvGf8SBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=naslG5MxxmqKLIV+Z1H4AwcExPULYIym7Tj3pANslk7YZhnjKN/uFiFBP2jYgQeTe
         FK6XHtkX4T7ZMaBYh7pInU/Ulfg/1y4PoXx9aAHVzjf+CBzOzdzrLV60H37eZR8XvW
         bbOlmwUOqCqrX0tzT8U/8Pl6t8KNohme6DjLXg2o=
Date:   Wed, 4 Jan 2023 13:38:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Zhou <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.19 0/1] drm/amdkfd: Check for null pointer after
 calling kmemdup
Message-ID: <Y7VzLI/GhGtne+78@kroah.com>
References: <20230103184308.511448-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103184308.511448-1-dragos.panait@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 08:43:07PM +0200, Dragos-Marian Panait wrote:
> The following commit is needed to fix CVE-2022-3108:

That's a funny cve, given that you can not ever trigger it in a system,
right?  Why was a CVE allocated for that?

{sigh}

