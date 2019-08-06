Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1113183ACA
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfHFVId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfHFVId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:08:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7A00206A2;
        Tue,  6 Aug 2019 21:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565125712;
        bh=GVJT36i+B1c1P9Eux3j+gLkdL3kluaPWthYH8PSCy0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iq+lCbQRYHGO2nFKYuguFeL0O61tZ87Y6gnGtTef423Z5Qmn0LjQms9eyGEcqvjzg
         uwWwg95Suahb9O+bE3uJXrmcFPvIkZGzdKIZqgNBVx7ByS8j9g8DFQKbHwtTIyTLgA
         yx0KZtvedwlWDmhOHsku5ZUE4oonKE7I6SCvzAEw=
Date:   Tue, 6 Aug 2019 17:08:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: logicpd-som-lv: Fix Audio Mute
Message-ID: <20190806210830.GJ17747@sasha-vm>
References: <CAHCN7x+Mbu=g1CgV2pbaojiwbej49aAmc5ufj8eacd-mcezEKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHCN7x+Mbu=g1CgV2pbaojiwbej49aAmc5ufj8eacd-mcezEKQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 10:19:24AM -0500, Adam Ford wrote:
>Please apply 95e59fc3c3fa3187a07a75f40b21637deb4bd12d ("ARM: dts:
>logicpd-som-lv: Fix Audio Mute") to 4.9 branch.

Queued for 4.9, thank you.

--
Thanks,
Sasha
