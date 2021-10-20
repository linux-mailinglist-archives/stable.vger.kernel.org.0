Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980C9434C3C
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 15:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJTNkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 09:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhJTNkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 09:40:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE54611C6;
        Wed, 20 Oct 2021 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634737111;
        bh=rkExu0/trkVm6o2QBuqOHlvclhCHhlsHyAmz/vFHI8M=;
        h=In-Reply-To:References:Cc:To:From:Subject:Date:From;
        b=NzV5YjWX/+omSv2oDWWY80mhFNxks7Np/0/lnx4uL50S5cDtQmyVIMg2ogCuM/7m4
         TeETcmIFkwTPwyjLmIftGwDqqu/z5sVme5Ur1mpn/NpTHe+lil5mn2I5MxhWv86np6
         UXN+uLg4Z3uFieWFOqfAOoZxhqNzzicd0kXXdmEmDg1aFtV4b0Tdz8yLihPlATwc7G
         1eN/CK412Pr4EfMdQgJtZhUS6BQQ66pO/WuJKEsfN2TUijeYNdL7PZ0Jh2ikmzQgs9
         SQZkay4Qt7Ert/34ZfCDDkpv9qLVBvgre82CiusinVfl+Oi4eUXAL/Xefyd9GZfwTb
         iLz2U+OBhMeHg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <03ba2e41-6ae6-d4ee-ace5-055ac40c1128@linaro.org>
References: <20210909085613.5577-1-atenart@kernel.org> <20210909085613.5577-2-atenart@kernel.org> <46d6d30201e11422f57bd79691133dc0491bd4c5.camel@linux.intel.com> <03ba2e41-6ae6-d4ee-ace5-055ac40c1128@linaro.org>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        amitk@kernel.org, rui.zhang@intel.com
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2 1/2] thermal: int340x: do not set a wrong tcc offset on resume
Message-ID: <163473710782.3319.6254396851923671939@kwain>
Date:   Wed, 20 Oct 2021 15:38:27 +0200
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Daniel,

Quoting Daniel Lezcano (2021-09-24 19:40:13)
>=20
> I've applied the patch 1/2 to the fixes branch and the patch 2/2 will
> land in the next branch as soon as the next -rc is released with the fix
> and merged to the next branch.

I don't see it in thermal/next even though patch 1 has made it. Not sure
if patch 2 has slipped through the cracks or wasn't pushed yet. If it's
the later, please ignore this mail.

Thanks!
Antoine
