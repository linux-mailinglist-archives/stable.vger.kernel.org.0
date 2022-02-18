Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBED4BB5D1
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbiBRJlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:41:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbiBRJli (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D185EDCF
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:41:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D4A461CC1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2016DC340E9;
        Fri, 18 Feb 2022 09:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645177281;
        bh=qTFnzVZgGa4Q1uJ14zva29njnnBXVCxKl8w/2PJHwmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vUvvgy1lENQGSvGBM10I/NP8zBl5P+wUUQeER7ucNlU0lKtkIvmDFydHkaRhva0vK
         QZ1918F1HA+VBooeskNrKF6oFkfTmAkLs6NjIM5LfrKfiX6OweQDqioRW9olZrBDql
         JwL97QMd1bvkM+HbGmRsJZImpxbQsZa6lY15ilwA=
Date:   Fri, 18 Feb 2022 10:41:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mickael GARDET <m.gardet@overkiz.com>
Cc:     stable@vger.kernel.org,
        =?iso-8859-1?Q?K=E9vin?= Raymond <k.raymond@overkiz.com>,
        Tudor.Ambarus@microchip.com
Subject: Re: Atmel UART with dma enabled does not work on branch 5.4.Y from
 version 5.4.174.
Message-ID: <Yg9puicPxjhUimMa@kroah.com>
References: <b8147153-5bcc-8a6d-7aac-5c0abbd43379@overkiz.com>
 <Yg9dAZI3hSbD9Epl@kroah.com>
 <1ed07d2b-ab56-4b55-bb7d-e858e0f1cf92@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ed07d2b-ab56-4b55-bb7d-e858e0f1cf92@overkiz.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 09:59:34AM +0100, Mickael GARDET wrote:
> Yes sorry,
> 
> enclosed signed patch.

That worked, now queued up, thanks!

greg k-h
