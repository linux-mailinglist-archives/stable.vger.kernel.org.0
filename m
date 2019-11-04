Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB9EE0CF
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfKDNOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:14:53 -0500
Received: from mail-lf1-f53.google.com ([209.85.167.53]:38248 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbfKDNOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 08:14:53 -0500
Received: by mail-lf1-f53.google.com with SMTP id q28so12231291lfa.5
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 05:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WMEf75w9oTagZRQTZzN7l66ng3i5+ieYjRbW8mGQvLE=;
        b=lagxcqO9BFG+5tBBWGjO/MIu8tH/fFE9Gxtrjq2WCr7OSpNkq9wThHjLZtIaP/Z3/d
         llCbpUKdJhZWEogUhme8/naioG5rI2AAMpsqphTfKmtvPvLF71r5wTq53R8Jm6SJagjn
         ZV3+KfhiQOeWSz5zXnjT1qzsUg8Y+bcyc6BiMXJrdaa+i0Ws2VtGKLUu3u4y9Ldgf4mR
         rPgBcWVJ2SszHsiFx26VFlwiecPFrb8b5yn3G8FPMl+PMrgHu2WIL9slyliZGjMnxeSX
         TRGmRmfPZTIvNLyLOIb0N/2PIZLCBYpo2WHhrXi3hqrwBXKYvspCj/n0pKn844SCh3Be
         NBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WMEf75w9oTagZRQTZzN7l66ng3i5+ieYjRbW8mGQvLE=;
        b=SopOOWmHYIOmzTK/ZC/5Int1o31hJ/9GmMqwrKeuvBu4BGdP0nHppqIQQ/V4dE9+a1
         7kY8lKg8yR6CFxWq4tNS9m3+XXkFrHkxfOsiAyZLW0QlM2KWUlGZ3D9n0pwLMQ5eQzje
         iA4AwegM9ds/K4cfAI3OxniWHvC7IOe37uqBlntzCB4nMQWAZyZfXtvEwlfI2IA3jWM2
         gqFC9eKisRJcq2c8hjYfFwWxLht8KBf98fnuzKZ2M/4+oloHlMDBnljS4ygENH4CRhFl
         y7m7kgMppKa0L7GUXSoxvrJfVpJCsQiVKPjDfwZDOX1m04NWhVvq3ZZgsdlJctfP6yfs
         Mgxw==
X-Gm-Message-State: APjAAAXwqS/ZPHditAhiJn8ogwmBWomlNqeiFmMMj37rC36nTwD2/33J
        V8GthvlDNJEVw9fOFWlS+xhx/ha6LAmZDx6kvWfakg==
X-Google-Smtp-Source: APXvYqyXlHJrIntltQv8i8RV7fF+BbSZCuGIhS2LO0/Un8NILT1G3+ClWfvxx+fQbF2wluVplwQyGzi4uJCkpuEw9Jw=
X-Received: by 2002:a19:f811:: with SMTP id a17mr16390181lff.132.1572873290596;
 Mon, 04 Nov 2019 05:14:50 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Nov 2019 18:44:39 +0530
Message-ID: <CA+G9fYsnRVisD=ZvuoM2FViRkXDcm_n0hZ1cceUSM=XtqJRHgQ@mail.gmail.com>
Subject: stable-rc 4.14 : net/ipv6/addrconf.c:6593:22: error:
 'blackhole_netdev' undeclared
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 4.14 for architectures arm64, arm, x86_64 and i386 builds
failed due to below error,

net/ipv6/addrconf.c: In function 'addrconf_init':
net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared
(first use in this function); did you mean 'alloc_netdev'?
  bdev = ipv6_add_dev(blackhole_netdev);
                      ^~~~~~~~~~~~~~~~
                      alloc_netdev
net/ipv6/addrconf.c:6593:22: note: each undeclared identifier is
reported only once for each function it appears in
net/ipv6/addrconf.c: In function 'addrconf_cleanup':
net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared
(first use in this function); did you mean 'alloc_netdev'?
  addrconf_ifdown(blackhole_netdev, 2);
                  ^~~~~~~~~~~~~~~~
                  alloc_netdev

Build link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.14/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/632/consoleText

- Naresh
