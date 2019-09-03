Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED1A5FF1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 05:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbfICDzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 23:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfICDzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 23:55:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76CE21881;
        Tue,  3 Sep 2019 03:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567482903;
        bh=VAjmcaozVfeTS1zqJudyO3Boo1KnPwJ6y310ZcaUFGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=prFSsBuiUzFV1WfF7hmiAfUzVQptzKWv2E/V1Ds6McMTtRdaLZj/39yfdYav0lMhu
         9OYU+QN0t69NaDTSX48+rj3e9RoU/gV93RTpKQJZ6lZ+i8Mzbyq1fIT6y3edf4RIg8
         G0yDtYP8h3OTIR0uM9F/mngMUcmlzOnVlvNdPSb0=
Date:   Mon, 2 Sep 2019 23:55:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     benjamin.tissoires@redhat.com, lains@archlinux.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] HID: logitech-hidpp: remove support for
 the G700 over USB" failed to apply to 5.2-stable tree
Message-ID: <20190903035501.GF5281@sasha-vm>
References: <1566809375118175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1566809375118175@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 10:49:35AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.2-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

It was a context conflict due to our backport of 27fc32fd94179 ("HID:
logitech-hidpp: add USB PID for a few more supported mice"). I've fixed
it up and queued it for 5.2, it is not needed on anything older.

--
Thanks,
Sasha
