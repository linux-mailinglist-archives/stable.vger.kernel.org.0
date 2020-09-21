Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC06B272B19
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgIUQKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbgIUQKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:10:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BB220708;
        Mon, 21 Sep 2020 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600704601;
        bh=1pQktWzBjJ9+zVrQyK29aZ1QdJ8O136uHncBqMRISQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mBOpFY1Tt93hr3UW+Fwel7xAUVZHACFeEvppea+x2vKyXnLQRMmsIy6zqNHytXHoM
         +LF+J8QjUqmurMBGdD0a6K5p8NGOTp1GQmdQMMuZ/kMOG/ru/vkhdoAwgkAZXEOjGY
         Zn2YJ4rRerxwWxkhPKurqolDWvXdNqYVNqj8/h34=
Date:   Mon, 21 Sep 2020 18:10:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ASoC: SOF: intel: hda: support also devices with 1 and 3
 dmics
Message-ID: <20200921161024.GB1096614@kroah.com>
References: <20200918161533.166533-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918161533.166533-1-pierre-louis.bossart@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 11:15:33AM -0500, Pierre-Louis Bossart wrote:
> From: Jaska Uimonen <jaska.uimonen@linux.intel.com>
> 
> [ Backported from Upstream commit 3dca35e35b42b3405ddad7ee95c02a2d8cf28592]

There is no such commit in Linus's tree :(

