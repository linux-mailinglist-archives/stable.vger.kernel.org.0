Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603FA3D21C7
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 12:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhGVJ3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 05:29:32 -0400
Received: from mout.web.de ([212.227.17.11]:52957 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhGVJ3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 05:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1626948606;
        bh=AvlCrQmD9OJ1+lL/BRCB+v4cOg68WKsJxnLX8LWc23U=;
        h=X-UI-Sender-Class:To:Subject:From:Date;
        b=iCSzje2Rwe4J0zztsJcc6sXlqXmRchPFFOrqX161dRBx+RTla8KwO3iEPDSZ8vgsH
         4aXCE0rVYRpjmZt+ofI6NfHgJeAC+sADeaRT933vkLm8dIETKgZeb3T7KxT2EqFH+j
         c/6oYWZOERgCI/jdqQJ094nm0Z87/ZOc6s8UfGFM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([178.9.212.178]) by smtp.web.de
 (mrweb105 [213.165.67.124]) with ESMTPSA (Nemesis) id
 1MjBVv-1lTtVb1gCD-00fCl1 for <stable@vger.kernel.org>; Thu, 22 Jul 2021
 12:10:06 +0200
To:     stable@vger.kernel.org
Subject: Kernel 5.4.134
From:   secret <andreas-stoewing@web.de>
Date:   Thu, 22 Jul 2021 12:09:54 +0000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <202107221209.57475.andreas-stoewing@web.de>
X-Provags-ID: V03:K1:DrWl+dznGmd8b1plzOpLKGf/MgEOo5vWAl6lhzVdEVaqzb1236p
 skuf0MqTyu5treUPSEQfN6Ri0sIQBu+5BNzGAFMXeYNwNIFMx6KB7w0G7iyVdhuA/Mj9d+2
 /+gJCm5v6aSeDYZh7HJ0fQnT2WwXIWckTWxBD172C/NCK50LDWdIn6g/tn4rlo8StkDmNNf
 T/y72J9FoKMjkAVOZUNxg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lYYmsDqFWMw=:oCp2KqdONiE3kvWhAxIpf4
 RC2mBrijGE3LI+u/vpLjB9uqn06icHgXBp9uxKHeRl+6AY6aXXMKJrOe5FVWyO3LZtk/prQpN
 6T9cFHzZXVstEWN6iLHSs3nR7cZbDo10e18Xc/EvOZ96AMriwbbRV9hpvwJbLFyCeDxvar3UT
 ENaF+ziH1K0V5WEYnz7aWRbrrzNm3IZrbY6zYH8SYaviY2y4hUvoYv1r75tgXKK0vdWeM+biw
 5mDQeCntUzCGYZhu6naGvKf2KhdB/hKufPdcrl/I+mOOA5MteY9ZoXIP0IXI2GBMN3p3YwS0i
 uO+U3S67ngfnk9K9Eyfn6j6d3qgcM+zSVIkLsrGnVoAPRGUNxlABbvqF49BPYEHx35lr/tB27
 7XS4bY4x1VCjY/9yIyDPpb0MKi2Z7i9SSWAOzg+cxQdB9th1a0i5aYvYEbOejhs7LuZwQXODC
 JFmaakPKCjWW/ZfXsQbSrzM8Dt4hs1YaZwvn0lxjFt6xF/EJ/iXefJnc46zwWR8oMIS0Jxld7
 ulrDeWja9iOwoms5rpiakAi6rlRppbYwwktc+OkiwyNrdXOMks1dxTH0UekRtiaBpsyHiAtz1
 6xPZrNMVjRQYYC1rNkJs9yuim+1C+qIc9pvY4l6hIX6rb/G2/Q2YZwtmN3aLG6VEGjX3a83u8
 Aa36FY3MPzp0TDDIyoZF+8NcB3PNRY+H1Y3MZGV/zy2pcNM5brHUgTTd2iQB6B+4+RbPpPA3K
 BUibbm6xFIfUDYQGzNLkVGldnsd01sL7Y2lRDDsrT2wzK87mC+7y/0LaS8r7JoriGUjbz1V6o
 V96xr1MgN9Vm5V9TJZ/6Ktm2nTmeQm7y+w1U5d6F++jWDjnEgmK+iduK8K50q1Jtsk/maUlZN
 6zzBdGLZE4Op/Q/x+HA37JVpuZGLJeVCrlf9SLu7NjAQgFvbfVaDCMrA12gqBlfpMNFbpg1/z
 NWyS6ZQOZ9MM8DTZQDCsgbVbDwiZnY4jpasKHp5IjgKu+n1kKcDzXLeQjzd8fIbFOR/bVehez
 s9xZTKCtSgoCEYnOKI8/t3k4f5FuS5VrkU73AynS3YybcjmK0f/Sc0Z6GLWqbMQRsJypdtrOQ
 WQBHq2po9wQgyvXfvZB/WH2tEW3dVxWKiL9vtSUcOLmQu0K7jR16Bcn9Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello,

I write again the content of my last E-mail to you, for  my smartphone has=
 got
only a small display and therefore a quit tiny keyboard...

Whenever Tor from rosa2016.1 (Rosalabs.ru) and/or Enterprise Linux 6 is
starting, at least three kernel-processes start too and/or become more tha=
n
active (CPU capacity lies by more than 10 percent, making my orange LED on=
 the
tower blinking a lot)!

So they have got root-rights!

Their name is like kworker-kcryptd/..., dmcrypt/... and uksmd, but this is=
 not
their complete name.

I do not want this activity as they irritate a lot in possibly causing hig=
h
and highest risks!

Tests have shown, that no data seems to get transferred over the net, but
knows the hell, what's really going on here....

Is it worth a patch for you,
can you resp. your foundation patch it?

I would appreciate this.

Regards, Andreas

I also like to tell you, that this Tor is surrounded by firejail from pclo=
s,
this is PCLinuxOS 2021. The processes get permanently highly active for ab=
out
five (5) minutes. The LED on the tower for read and write on storage media=
 is
really blinking madly hard all this time, while the process-manager confir=
ms
the whole mysterious process-activities!
After this time, Tor and surfing in the internet with the browser do work =
fine
as much as the rest of the Linux. So I have to wait several minutes.
Does it have to do with one of the last patches of 5.4, for example the on=
e
for dmcrypt? Anyhow I use full system encryption by LUKS, that might matte
here.

Regards,
Andreas St=C3=B6wing
(Gooken)
https://gooken.safe-ws.de/gooken
