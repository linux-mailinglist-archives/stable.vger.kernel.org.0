Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6241463B4
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAWInx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:43:53 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42994 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWInx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 03:43:53 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id D7AAB29311A
Subject: Re: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using
 adb over f_fs
To:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20200122222645.38805-1-john.stultz@linaro.org>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com>
Date:   Thu, 23 Jan 2020 09:43:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122222645.38805-1-john.stultz@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi John,

W dniu 22.01.2020 o 23:26, John Stultz pisze:
> Hey all,
>    I wanted to send these out for comment and thoughts.
> 
> Since ~4.20, when the functionfs gadget enabled scatter-gather
> support, we have seen problems with adb connections stalling and
> stopping to function on hardware with dwc3 usb controllers.
> Specifically, HiKey960, Dragonboard 845c, and Pixel3 devices.

Any chance this:

https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commit/?h=testing/next&id=f63333e8e4fd63d8d8ae83b89d2c38cf21d64801

has something to do with the problem you are reporting?

Andrzej
