Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7376478B3D
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 13:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbhLQMSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 07:18:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33990 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbhLQMSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 07:18:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BBF262127;
        Fri, 17 Dec 2021 12:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6C9C36AE5;
        Fri, 17 Dec 2021 12:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639743490;
        bh=l9Fw98fxYTAzfXr3dvrugWjvZUyMpJiAwv+9rxyfnug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s7XhpOTcR37SYDl8+62vPVoWiiAMgIo5OvNkRLgzMDzYp7E3W22Nc8TT6531V9lig
         4vKnEsml7FzolyZl1DF6eH3j7Vq9OIueHF+tE5VPqvlVAKcEhB2uG8Aboas2mONd2c
         mBSyWtpCK0/mGDJioKHwp7Zi4Uy47FRwjNh119Kg=
Date:   Fri, 17 Dec 2021 13:18:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: stable request: 5.15.y: reset: tegra-bpmp: Revert Handle errors
 in BPMP response
Message-ID: <Ybx//1HudbEsCRG/@kroah.com>
References: <d917c97d-8023-419c-06c3-d471097fbd7b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d917c97d-8023-419c-06c3-d471097fbd7b@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 11:12:50AM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> Please can you include the following commit for 5.15.y? This is the last one
> that we have been waiting for :-)
> 
> commit 69125b4b9440be015783312e1b8753ec96febde0
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Fri Nov 12 11:27:12 2021 +0000
> 
>     reset: tegra-bpmp: Revert Handle errors in BPMP response

Now queued up!
