Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6528435E8A
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 12:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhJUKFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 06:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhJUKFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Oct 2021 06:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 818D1610D0;
        Thu, 21 Oct 2021 10:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634810567;
        bh=oWHlzrPAFbHmooBdr5j39h+cg5RJrhVi+0UPE8jqoOE=;
        h=In-Reply-To:References:Cc:To:From:Subject:Date:From;
        b=jBnu7HSv6CCYPXSrdFX6D2SE39i77b8M0r9/EUpQFvYWDVvwh+kL7rRdfXGRupsVR
         w7HUcu+Pa9LCt6zSAlxgJn58z3y+VhMHMMywatrApZKYkFoMakG1tUCsyLJ1FztBUp
         9e9x2xjOK2yNiWR/yNpwg3Xvzy45xgQ7CIIxR+NnAuJYmfPttNQNb98ijywxRsP1IS
         iqDwAArLt5SHDFALRXuy0nBIvJbzsKk3a/N3rFwQjaMHuBbV2MWV+z+P06RIYX0lHG
         0JQvYAb/ltmEQF8yZEWyrrY+/ms6lkxNNZDGbTFp3YHVizbLwZNfL8CZXBhaIgq+om
         fIZOzI2H9SPgA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <d698f116-bb2d-e6ff-31a3-29cd0adf11d4@linaro.org>
References: <20210909085613.5577-1-atenart@kernel.org> <20210909085613.5577-2-atenart@kernel.org> <46d6d30201e11422f57bd79691133dc0491bd4c5.camel@linux.intel.com> <03ba2e41-6ae6-d4ee-ace5-055ac40c1128@linaro.org> <163473710782.3319.6254396851923671939@kwain> <d698f116-bb2d-e6ff-31a3-29cd0adf11d4@linaro.org>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        amitk@kernel.org, rui.zhang@intel.com
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2 1/2] thermal: int340x: do not set a wrong tcc offset on resume
Message-ID: <163481056386.3319.11688622907532067907@kwain>
Date:   Thu, 21 Oct 2021 12:02:43 +0200
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Daniel Lezcano (2021-10-21 11:47:50)
> On 20/10/2021 15:38, Antoine Tenart wrote:
> > Quoting Daniel Lezcano (2021-09-24 19:40:13)
> >>
> >> I've applied the patch 1/2 to the fixes branch and the patch 2/2 will
> >> land in the next branch as soon as the next -rc is released with the f=
ix
> >> and merged to the next branch.
> >=20
> > I don't see it in thermal/next even though patch 1 has made it. Not sure
> > if patch 2 has slipped through the cracks or wasn't pushed yet. If it's
> > the later, please ignore this mail.
>=20
> Indeed, I thougth I picked it but it wasn't.
>=20
> Thanks for the head up, it is applied now.

Thanks!
