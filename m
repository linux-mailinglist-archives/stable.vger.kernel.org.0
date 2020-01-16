Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD0113F9AF
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgAPTmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgAPTmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 14:42:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6699520684;
        Thu, 16 Jan 2020 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579203729;
        bh=rQgpbX8LAygTRd2At6fu4MoZ2wn2i4g1oDTxF/qqrXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pSqTKgh6wvZzQDkJrAExH2wpBpNadv6KRAoL5YdKGi8qzWb26ZKDKOUUI0ugFYDuc
         6z9DsqnysMTNGHV0TpxmlI8KyO/Q2zj1h6XxsJ4McVZdy2k43vAZmjq6y8+7brTtAv
         7IUgFD+1frXcSJl3rE3+i32oYOZEt+E5WE7npUmo=
Date:   Thu, 16 Jan 2020 20:42:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 0/2] Fixes for navi14 in kernel 5.4
Message-ID: <20200116194207.GB1024193@kroah.com>
References: <20200116162429.4000-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116162429.4000-1-alexander.deucher@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 11:24:27AM -0500, Alex Deucher wrote:
> Hi Greg,
> 
> These patches fix hangs on boot with some navi14 boards in
> kernel 5.4.  These patches are cherry-picked from 5.5.

Both now queued up, thanks.

greg k-h
