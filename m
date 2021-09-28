Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DD941A982
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 09:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbhI1HSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 03:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239230AbhI1HSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 03:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CE5F611CA;
        Tue, 28 Sep 2021 07:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632813388;
        bh=aO4k7E82Uf3bg12fw9WjNJlPCRsQ1E3TxeQQK2GPy2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SIwbx3aMv2GlnefaxTDSaRE/R5ge7U+/Nwmdoaz9jZuCBCedOYIbY0XKuwdhM30bp
         m/xVkem1ZcWCo9Mpib0fu7zOAPc+ZoYIZUYZe5c8JIiG4zHBDgCp9JR1bP8K5TEYda
         5Z69Bgq4iYN7eldyD16cUH/b+q043Vq8LP3JIR/0=
Date:   Tue, 28 Sep 2021 09:16:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 048/103] s390/qeth: fix deadlock during failing
 recovery
Message-ID: <YVLBSrKXKFVnaGAH@kroah.com>
References: <20210927170225.702078779@linuxfoundation.org>
 <20210927170227.414776158@linuxfoundation.org>
 <CA+G9fYs2a78_RXaqfE3WMjSOh=HhuS=OjVxh9Hswzrme+pqxqQ@mail.gmail.com>
 <CA+G9fYvjwocyLdMt9a-QgPfvvWNcDOwhO-S1+RmPxkPewrykjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvjwocyLdMt9a-QgPfvvWNcDOwhO-S1+RmPxkPewrykjw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 11:55:00PM +0530, Naresh Kamboju wrote:
> On Mon, 27 Sept 2021 at 23:15, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > Following commit caused the build failures on s390,
> 
> Also noticed on stable-rc 5.10 and 5.14 branches.

Thanks, now dropped on both branches.

greg k-h
