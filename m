Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59971415A47
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 10:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhIWIvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 04:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240040AbhIWIvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 04:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32BCD60F3A;
        Thu, 23 Sep 2021 08:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632386978;
        bh=2kXPtHmpiD8scrzgNj6Btgo4zZ4dC9HBBLTgcUSYozM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sx9SzIxQ3AW6zi0EJV+zpwJAIG2Bp6/R56ZQsi0nEbr7/+b4ENpl1nnVB4ggk7/Ab
         /8HurMS7/cBcZ9CGBe9v2adamIQkU0xX6LZBMH7fFv5XZw8Bj7elKV/TvcQQ7vcSK3
         xtmZfqNxz7mv5cBr9zfPFWeLtw9fHtmMgurKWM8XZLcURWhXFUQF79cWXEzqF8r0G6
         MrLu37Z+YdJp8cMHFmas1MVRxv0Hjtoq11YrhBt+9mtowC+tpFO3C2Y5dkGa7AG5Nt
         Yb8SYe6jUePdMKDC/juA5/OGWV8Go/UjtC8dVUrUDqc9R+4JQ/TMTkwCEgF3iM140c
         mMniCMbWN/qBQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mTKQE-0000zQ-Mg; Thu, 23 Sep 2021 10:49:39 +0200
Date:   Thu, 23 Sep 2021 10:49:38 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Malte Di Donato <malte@neo-soft.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: serial: cp210x: fix dropped characters with
 CP2102
Message-ID: <YUw/ogHjD1EBwG9d@hovoldconsulting.com>
References: <YUsTYFOdMH/kQEyE@hovoldconsulting.com>
 <20210922113100.20888-1-johan@kernel.org>
 <d291a449-cf66-9c02-5ba2-3aee6f73af21@neo-soft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d291a449-cf66-9c02-5ba2-3aee6f73af21@neo-soft.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 22, 2021 at 10:12:48PM +0200, Malte Di Donato wrote:
> Tested-by: Malte Di Donato <malte@neo-soft.org>

Thanks for testing. Now applied.

Johan
