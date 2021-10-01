Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90A241F28C
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 18:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhJAQyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 12:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhJAQyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 12:54:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17DC861A7A;
        Fri,  1 Oct 2021 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633107187;
        bh=sJh/dsLubZoEaFoSM354OibFNeU0tL020AnSI76i2cU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VeWOOy0dih4geDK+azHTNMX9KrLtEnAfHOJtewz/UWcu8chYDjIIDg0UwUcnIyaix
         mCxdqbujuzZlcogXsOPLDU9E6ql74EpsI2N9yza4OAaKI1nQYwlmtDtvRlqKCNBJf9
         I4aBWG7HkFlxSuN2BqCiI0sGEpb4xuZo507AbbEbFmK8zKdTinTyLy73gksd+3wHJe
         yy+QbSyeTNPPCjW75xu2UAYJJo9IIo8NyTxsYBPT2PvOhaseuo81U6/GZrUUK0OGHW
         XZmYbFcraPqoSLYR3j65BuTbugNSi+SJeYFdRpoLIEKXVUD+ozg5TX0XvetwNFrUKv
         6xJpdq/7tVg0A==
Date:   Fri, 1 Oct 2021 12:53:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.14] scsi: ufs: ufs-pci: Fix Intel LKF link stability
Message-ID: <YVc88vbDPrR3MH1/@sashalap>
References: <20210929133601.53705-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210929133601.53705-1-adrian.hunter@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 04:36:01PM +0300, Adrian Hunter wrote:
>commit 1cbc9ad3eecd492be33b727b4606ae75bc880676 upstream.
>
>Intel LKF can experience link errors. Make fixes to increase link
>stability, especially when switching to high speed modes.

Queued up, thanks!

-- 
Thanks,
Sasha
