Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DBF536C5E
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 12:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbiE1KpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 06:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344448AbiE1Ko5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 06:44:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2E02C5
        for <stable@vger.kernel.org>; Sat, 28 May 2022 03:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28D0EB816F6
        for <stable@vger.kernel.org>; Sat, 28 May 2022 10:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243D6C34100;
        Sat, 28 May 2022 10:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653734693;
        bh=iYwjTsRVPKWui9GIHExFQZisvymehRhVgol5P4PHBLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h54+qO7NVZcz29rM9nu6qAhZH/J1An2g5m3ev2bksJxifiwPpRWYhs2GV6/rCntN2
         BNqWHkmF0AUhJlwR00A4ZxFQiOVyXUyZNeYTjMV0kWQVCIQdeA7y9J9GAp8BWsslyh
         ofJS5m/9+E08CGLvc9vBmGC834JRk6MkSBhLjiDU=
Date:   Sat, 28 May 2022 12:44:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schroeder, Julian" <jumaco@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] nfsd: destroy percpu stats counters after reply cache
 #5.11.0-rc5
Message-ID: <YpH9IZ9Q+o4XERqR@kroah.com>
References: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
 <Yo9t7Whg/XGa/jmb@kroah.com>
 <08D60925-9EF7-4A3A-852F-5F6B8FF23AE6@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08D60925-9EF7-4A3A-852F-5F6B8FF23AE6@amazon.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 07:39:36PM +0000, Schroeder, Julian wrote:
> The patch made it into linux next. commit fd5e363eac77e.
> I sent the patch to stable again via git send-email.

I have no context here at all, sorry.

What are we supposed to do?

confused,

greg k-h
