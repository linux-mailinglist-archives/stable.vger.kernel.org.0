Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DA5D8083
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 21:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbfJOTpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 15:45:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41962 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1732528AbfJOTpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 15:45:53 -0400
Received: (qmail 2522 invoked by uid 2102); 15 Oct 2019 15:45:52 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 15 Oct 2019 15:45:52 -0400
Date:   Tue, 15 Oct 2019 15:45:52 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Sasha Levin <sashal@kernel.org>
cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        <linuxtv-commits@linuxtv.org>, <stable@vger.kernel.org>
Subject: Re: [git:media_tree/master] media: usbvision: Fix races among open,
 close, and disconnect
In-Reply-To: <20191014035427.DCD2B20882@mail.kernel.org>
Message-ID: <Pine.LNX.4.44L0.1910151544370.1462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Oct 2019, Sasha Levin wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.3.5, v5.2.20, v4.19.78, v4.14.148, v4.9.196, v4.4.196.
> 
> v5.3.5: Build OK!
> v5.2.20: Build OK!
> v4.19.78: Build OK!
> v4.14.148: Build OK!
> v4.9.196: Build OK!
> v4.4.196: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

As far as I'm concerned, it's probably not worth the effort of
backporting this to 4.4.y.

Alan Stern

