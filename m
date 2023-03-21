Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89586C269E
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 01:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCUA67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 20:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCUA66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 20:58:58 -0400
Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DA615C8D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 17:58:54 -0700 (PDT)
Message-ID: <efc7e85a-a170-ba1b-8746-b00784e81e39@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
        t=1679360331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGFSyM1EeO9gwFjQ6LUhyfz1rTBjgFZq1uGD1+sxDzU=;
        b=q2/czrvwHcCavbnEK/f2Jb/bFRs3n30GXJKvLJZ5E4jEJwBQCgLI4zUxiVgiqaXHIRlsei
        s4qBWNyEwodbkAwolDH0JwHzk0CXtF1N+DhZz/TX8Yp184T8/xr6IUaxpoQEvkNp1uqmCg
        G0WBFKXyZYUgIida8esxLPBfolNE1zbA2J0LRXyZEKSTf9rvxsOO8CcB5kz3iWlIElk6wR
        wCwgf+NVkP8rxZWrBQYPFIzj/CvyE1oobg7yRhErGPY2kpitsm/qcjDnjnJM5V4JiAX8ZK
        r2FrnQqxWNc1v34jaTirWI+SR0D+GqSqvUJBzhTg4xTfKOA3oLoaTSbeWWFeDw==
Date:   Tue, 21 Mar 2023 07:58:44 +0700
MIME-Version: 1.0
Subject: Re: [Regression] drm/i915: Don't use BAR mappings for ring buffers
 with LLC alone creates issues in stable kernels
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     John Harrison <John.C.Harrison@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <8a1bbe56-4463-d18d-d5a9-d249171a569d@manjaro.org>
 <a0be2b31-9e72-1254-978e-570b27abb364@manjaro.org>
 <ZBhfhJ0ylxqXPHee@kroah.com>
Content-Language: en-US
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Organization: Manjaro Community
In-Reply-To: <ZBhfhJ0ylxqXPHee@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=philm@manjaro.org smtp.mailfrom=philm@manjaro.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20.03.23 20:28, Greg Kroah-Hartman wrote:
> On Sun, Mar 19, 2023 at 10:01:01AM +0700, Philip Müller wrote:
>> Have to correct the affected kernels to these: 4.14.310, 4.19.278, 5.4.237,
>> 5.10.175
> 
> Please don't top-post :(
> 
> Anyway, should be fixed in the next round of releases in a few days, if
> not, please let us know.
> 
> greg k-h

Hi Greg,

seems the RCs work out. 4.19.279-rc1 and 5.10.176-rc1 were tested by a 
user who had the issue on i915. In 5.15 series the drm patch got 
reverted. I only see "drm/i915: Don't use stolen memory for ring buffers 
with LLC" there as "drm/i915: Don't use BAR mappings for ring buffers 
with LLC" was reverted with 5.15.101.

-- 
Best, Philip

