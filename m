Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D820032D437
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhCDNcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241300AbhCDNb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:31:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AB8564F09;
        Thu,  4 Mar 2021 13:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614864678;
        bh=LjVYf6aSX0deJEkxfvnZmq9ycXPpm4s8Pfamqhdpqzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ptCJT5jNmLUm1EaruBonNak4q8Mlxb9AjiCV9C3w/yT+DRRLdrFgBgjEnShE+8y1x
         qptgwRxag49JWT4TmnwOQ0V3KCtnXQCrVvk7vxxskbX2VYaLhPIB7HFdbQ1SOKOPpp
         U44zp0llZcGWrlC0L/CYrzv13aZsftVVGpBF/OLw=
Date:   Thu, 4 Mar 2021 14:31:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Frank Li <Frank.Li@nxp.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH for 4.4] mmc: sdhci-esdhc-imx: fix kernel panic when
 remove module
Message-ID: <YEDhI4n2kwuSr78l@kroah.com>
References: <20210302232321.854084-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302232321.854084-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 08:23:21AM +0900, Nobuhiro Iwamatsu wrote:
> From: Frank Li <Frank.Li@nxp.com>
> 
> commit a56f44138a2c57047f1ea94ea121af31c595132b upstream.

Now queued up, thanks.

greg k-h
