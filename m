Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4292546C40
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 00:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfFNWTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 18:19:03 -0400
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:49390 "EHLO
        resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbfFNWTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 18:19:03 -0400
Received: from resomta-ch2-04v.sys.comcast.net ([69.252.207.100])
        by resqmta-ch2-11v.sys.comcast.net with ESMTP
        id buK4ho85oRZD9buPOh2mLj; Fri, 14 Jun 2019 22:10:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20180828_2048; t=1560550254;
        bh=By1+KwAQDvxknCnYhgfG8EQ2r/nPs2JRxqJbokVnKho=;
        h=Received:Received:From:Subject:Reply-To:To:Message-ID:Date:
         MIME-Version:Content-Type;
        b=dG3Iz17apwlhG/iQ+o6Atj668/6gY2FrhQyL3GPtnZY2/5WR+wchomyasQ7KmkWMK
         Zn86aUE4Uar0XJ3uiDJSI+FkVmpNykl39KcsPHNq24SnRRzxZHrS6tGg6hq4BapuKt
         S1k38rm6ZilZORIgplUQ79/V3ms4TNmSxmd/vu8wmwR/pVDTzdGYNjL4ZsIzM1/Dr7
         l8MORpvdUwm7u/RGlJwIXli6RoH5C2f2vqC+I/Z2DpZEnAuzDlVH7GubFjhB+jQxXT
         R3aCc+GJxrJ6/pFUQ1g2+NKQLXkrBNTfVde/LmbnoMeb1LtJa286i7K+50Tf9UNUMn
         O40oukX2Cz3Jg==
Received: from [IPv6:2001:558:6040:22:2171:426f:b27e:296d] ([IPv6:2001:558:6040:22:2171:426f:b27e:296d])
        by resomta-ch2-04v.sys.comcast.net with ESMTPSA
        id buPMhbDdCXrm0buPNhURJ8; Fri, 14 Jun 2019 22:10:53 +0000
X-Xfinity-VMeta: sc=-100;st=legit
From:   James Feeney <james@nurealm.net>
Subject: Re: [PATCH 1/2] HID: input: make sure the wheel high resolution
 multiplier is set
Reply-To: james@nurealm.net
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Sasha Levin <sashal@kernel.org>, Jiri Kosina <jikos@kernel.org>
References: <20190423154615.18257-1-benjamin.tissoires@redhat.com>
 <CAO-hwJLCL95pAzO9kco2jo2_uCV2=3f5OEf=P=AoB9EpEjFTAw@mail.gmail.com>
 <43a56e9b-6e44-76b7-efff-fa8996183fbc@nurealm.net>
 <CAO-hwJK614pzseUsGqH65fCnrm=N7970i4_mqi0m1gdkY=J0ag@mail.gmail.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-ID: <b6410e5d-b165-7a9b-2ef5-eb44c8de7753@nurealm.net>
Date:   Fri, 14 Jun 2019 16:09:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAO-hwJK614pzseUsGqH65fCnrm=N7970i4_mqi0m1gdkY=J0ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Everyone

On 4/24/19 10:41 AM, Benjamin Tissoires wrote:
>>> For a patch to be picked up by stable, it first needs to go in Linus'
>>> tree. Currently we are working on 5.1, so any stable patches need to
>>> go in 5.1 first. Then, once they hit Linus' tree, the stable team will
>>> pick them and backport them in the appropriate stable tree.

Hmm - so, I just booted linux 5.1.9, and this patch set is *still* missing from the kernel.

Is there anything that we can do about this?

James
