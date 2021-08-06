Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB443E3201
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 00:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244155AbhHFXAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 19:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhHFXAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 19:00:05 -0400
Received: from smtp-42aa.mail.infomaniak.ch (smtp-42aa.mail.infomaniak.ch [IPv6:2001:1600:4:17::42aa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86B2C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 15:59:48 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4GhLXJ2N5MzMq0qZ;
        Sat,  7 Aug 2021 00:59:44 +0200 (CEST)
Received: from [127.0.0.1] (unknown [80.215.83.208])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4GhLXH6663zlh8T6;
        Sat,  7 Aug 2021 00:59:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=asdrip.fr;
        s=20210424; t=1628290784;
        bh=/HM09Nj0Qx9SGj94p+rupOxDI02p8E4Vc4zqgkwzNJs=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=YToR1BXDDTSihgfZrD56T55hXYa7mov52SBMLtX76zitgwQNBdNk70d4I+sJOq6mJ
         6Oync8pMldwm5/OGPsMjSe+FD94E/73Z7T/tYl4mBhBc8Vn+RV7p7/sTgxnFuhoKH3
         68dVsJtuMOVRDtzpoLlDyLxcyRIYLq9rIYXOY7l0=
Date:   Fri, 6 Aug 2021 22:59:41 +0000 (UTC)
From:   Adrien Precigout <dev@asdrip.fr>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Message-ID: <75ada57f-5021-4d62-8282-4161542684f8@asdrip.fr>
In-Reply-To: <2da0ad34-bd01-47b2-29fc-c2e8210e3697@intel.com>
References: <fc66decb-ed13-45dd-bf82-91f0cc516a30@asdrip.fr> <eb9250ed-2ae9-07d5-e966-9063fffa34f8@asdrip.fr> <YQY5rsWFhk5Okt0Y@kroah.com> <2da0ad34-bd01-47b2-29fc-c2e8210e3697@intel.com>
Subject: Re: Tr: Unable to boot on multiple kernel with acpi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <75ada57f-5021-4d62-8282-4161542684f8@asdrip.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Aug 3, 2021 16:21:13 Rafael J. Wysocki <rafael.j.wysocki@intel.com>:
>> Thanks for helping to narrow this down.
>>
>> Rafael and EriK, this is commit c27bac031413 ("ACPICA: Fix memory leak
>> caused by _CID repair function") in Linus's tree, that showed up in
>> 5.14-rc1.=C2=A0 Any chance you all can revert this, or provide a fix?
>
> I'm thinking let's revert and revisit in the next cycle.
>
> I'll queue up a revert of this.
>
> Cheers,
>
> Rafael


Thank you for your help ! Don't hesitate to reach me if you need more infor=
mation to help fixing it.
Best regards,
Adrien

