Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7A569C9BD
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjBTLYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBTLY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:24:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434FD18AB9
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:23:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0F3960DCB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3DFC4339E;
        Mon, 20 Feb 2023 11:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676892219;
        bh=g8EHqcl4piI0dKSU8Sgvd8urd/g6i4GCgx++D5N2NRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lt6huX+a30GL1wXK/zBj3efXdLlL7grE8geC8f8YOEmJpFSaNvSbt0+RM7Hyu2RDn
         emKUR/GmVESBpYiRDfsceYI7Sd+bLgLoVlFDE4jMzWz2KqbZuCtlmsDL8T0eSoUuXQ
         FijYzgpb6P0+DJbwgqjRob/ypEX+jM0wbfVBbaW8=
Date:   Mon, 20 Feb 2023 12:23:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org, broonie@kernel.org,
        alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com
Subject: Re: [PATCH BACKPORT 5.4] ASoC: SOF: Intel: hda-dai: fix possible
 stream_tag leak
Message-ID: <Y/NYOAkc+EuQsQgD@kroah.com>
References: <20230220111721.32502-1-peter.ujfalusi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220111721.32502-1-peter.ujfalusi@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 01:17:21PM +0200, Peter Ujfalusi wrote:
> [ Upstream commit 1f810d2b6b2fbdc5279644d8b2c140b1f7c9d43d ]
> 
> There were just too many code changes since 5.4 stable to prevent clean
> picking the fix from mainline.

Thanks, all backports now queued up.

greg k-h
