Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8043A4043
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 12:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhFKKgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 06:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231315AbhFKKgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 06:36:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C29E613DE;
        Fri, 11 Jun 2021 10:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623407684;
        bh=VFJTtZgTGvgwlAPxB+c53Gj4BcOkgELi3OWU6hIMh7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ktc4MNFWAkOn6BfDkWE5dnj6D2YC9slcqlpvYGzq06AIZH5Ar3hLAJwn4Ch9Jultn
         QelaOxUQAydPeXjh+JFSoEnhR/q6uMkTRrGi0Y0rQsUMx9BiENiiyDTQcFTz2xyepv
         pWVb9kqr+//dV70EtrZjhr/3OydxZHhYWUXGv4Ng=
Date:   Fri, 11 Jun 2021 12:34:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stable@vger.kernel.org
Subject: Re: [RESEND PATCH] nvmem: core: add a missing of_node_put
Message-ID: <YMM8Qrcr2YeiGh2n@kroah.com>
References: <20210611102321.11509-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611102321.11509-1-srinivas.kandagatla@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 11, 2021 at 11:23:21AM +0100, Srinivas Kandagatla wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> 'for_each_child_of_node' performs an of_node_get on each iteration, so a
> return from the middle of the loop requires an of_node_put.
> 
> Fixes: e888d445ac33 ("nvmem: resolve cells from DT at registration time")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> Hi Greg, 
> 
> Resending just this one with cc stable as rest of nvmem series are already applied.

Thanks, now applied.

greg k-h
