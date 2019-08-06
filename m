Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B6F83AB4
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfHFUzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfHFUzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 16:55:21 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66A4B20C01;
        Tue,  6 Aug 2019 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565124920;
        bh=LAT8rvop9WX/NwpJa2zcEiBJeICVPas0+TKrxWR9wGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LE2Jogz4v1z/HFvd9NU8CZF1UxX+SFBO2Zb4p5XAoLnz5KIao2EGiCrapliuGh+Qb
         eb+3CaD+NutkMoFmCX62v/na+XrzK1pF81CgN5mENO0YBwAZLL81kfjVIDQDVPeb59
         w+RQm5OZrv/2b498ifzFBrWGD+gR2DpbxMTOik9g=
Date:   Tue, 6 Aug 2019 16:55:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Adam Ford <aford173@gmail.com>, stable@vger.kernel.org
Subject: Re: ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV
Message-ID: <20190806205519.GH17747@sasha-vm>
References: <CAHCN7xJUd0ZmC86_NsS+8j+o5M0iQipGJuh00nV0=V=qt5Jtaw@mail.gmail.com>
 <20190806151512.GA6051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190806151512.GA6051@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 05:15:12PM +0200, Greg KH wrote:
>On Tue, Aug 06, 2019 at 10:06:24AM -0500, Adam Ford wrote:
>> Please apply 5fe3c0fa0d54877c65e7c9b4442aeeb25cdf469a
>>  ("ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV") to
>> 4.9.y branch.
>>
>> Ideally, it would be applied to 4.4, but It doesn't apply cleanly to
>> 4.4.  I can do a separate patch to do that, but I am not sure of the
>> proper procedure.
>
>Just send a backported patch to the list, saying what the git commit id
>was in Linus's tree.  THere are loads of examples in the archives for
>how to do this properly.

I've queued 5fe3c0fa0d5 for 4.14 and 4.9. It doesn't seem like it should
go on 4.4 because it doesn't have ab8dd3aed011 ("ARM: DTS: Add minimal
Support for Logic PD DM3730 SOM-LV"). If you disagree, please send a 4.4
backport.

--
Thanks,
Sasha
