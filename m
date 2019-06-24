Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAC550266
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 08:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfFXGeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 02:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfFXGeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 02:34:15 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A08FC205F4;
        Mon, 24 Jun 2019 06:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561358054;
        bh=FGQF4sZvocwPTEhWI9jzxLJPdOYoAZxnhsYW/SOnv0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUF7CbnF4q20GCFKfyd5+id3rV/EgIdoWg9hFuUrx6X3UMlTzpVWfnvXiyehOParc
         z9xA4ZnHiQlRbPqwc89ALYMaWaXK/Wu3zDBce/0oVgvm1Gn5MrIddHajLoxmXcU9KY
         0TB3udisS2Yqq65ZAIFFpLRLH1erf4Ib0F1yIpCQ=
Date:   Mon, 24 Jun 2019 08:33:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Btrfs: fix failure to persist compression
 property xattr" failed to apply to 5.0-stable tree
Message-ID: <20190624063351.GB30962@kroah.com>
References: <1561321295592@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561321295592@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 23, 2019 at 10:21:35PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.0-stable tree.

Ugh, there is no 5.0-stable tree anymore, this should be 5.1, sorry for
the noise.

greg k-h
