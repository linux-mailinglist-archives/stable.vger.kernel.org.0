Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECD1A5AEE
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfIBQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 12:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfIBQA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 12:00:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89E921881;
        Mon,  2 Sep 2019 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567440055;
        bh=mJwEXeh9CSD/UGKpq5I8/EKKhuH0yp4LBIc3MRNKusI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IokDy13upxRjfjtUAgiANVVb5OnMLv/ypAQlXMRYwgf7PNYfawBES++kL3BndpSyq
         wmRXla5ruFdg/4tW1jDyC7volEhHr3UqY75gAI2gconNIjwmU+MH2nmHgpOo8zWGXa
         yjHRGES2Yuocvxc4Ka10XexzBKcrvhehbuY4UkEs=
Date:   Mon, 2 Sep 2019 18:00:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hui Peng <benquike@gmail.com>
Cc:     stable@vger.kernel.org,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Wenwen Wang <wang6495@umn.edu>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a stack buffer overflow bug in check_input_term
Message-ID: <20190902160044.GC21884@kroah.com>
References: <20190830214730.27842-1-benquike@gmail.com>
 <CAKpmkkWv2cjrJCkVhGmEMnLG2_kCNxdbt29dZ8j-UM8Cf3quGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKpmkkWv2cjrJCkVhGmEMnLG2_kCNxdbt29dZ8j-UM8Cf3quGQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 30, 2019 at 05:51:17PM -0400, Hui Peng wrote:
> This is the backported patch for the following fix to v4.4.x and v4.14.x:
> 19bce474c45b ("ALSA: usb-audio: Fix a stack buffer overflow bug in
> check_input_term")

Now queued up, thanks.

greg k-h
