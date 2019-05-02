Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA36711849
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfEBLna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 07:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfEBLna (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 07:43:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F4B12081C;
        Thu,  2 May 2019 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556797409;
        bh=rMZ1G6I7pd99oy9CmGkb+WRwGt2tA+P0LHU86Bu1Qlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t6jSA+/PjLEpu8PqgOGdgYnMhvs/fB65Tu2aX2xY6QksSClwh32AFzXSLgqqaKftO
         jXyNAPb5crkqATRc08iwgm3Rnd2s4i1342p6rBBwFMthsmRTSymqQjj2MgnLAzrCxY
         GzKWWesJPeEIyHVxsAt5twbKSZq/QlK8lFvA4bhk=
Date:   Thu, 2 May 2019 13:43:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Alexander Kappner <agk@godking.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4.4,v4.9,v4.14 1/2] usbnet: ipheth: prevent TX queue
 timeouts when device not ready
Message-ID: <20190502114327.GA21563@kroah.com>
References: <1556668410-31439-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556668410-31439-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 04:53:29PM -0700, Guenter Roeck wrote:
> From: Alexander Kappner <agk@godking.net>
> 
> commit bb1b40c7cb863f0800a6410c7dcb86cf3f28d3b1 upstream.

<snip>

Both patches now queued up, thanks.

greg k-h
