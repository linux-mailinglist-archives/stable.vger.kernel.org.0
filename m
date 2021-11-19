Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E287457971
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 00:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbhKSXVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 18:21:14 -0500
Received: from mout.gmx.net ([212.227.15.18]:36471 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhKSXVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 18:21:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637363888;
        bh=92IDGtqdfCGF8d2HARzb6+7JeJlTxKoq82CETOlvhr4=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=lsKGY7DBX7WGpywlvo2KEKGvFqiQF7nYIwtyaFV+AiOuLDMmRoP1tiuwVwTwrvyHp
         D4MNB/hYE5rx008E4RbxYGrvoZj/zmOcGo3H6t7UrSmlcyTyrMQwzQuzYw4Zcdwz7J
         AfzAN6hFgQ3UVWCxn5uQaLbrSmELOvqpICZYfZn8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.20]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfHEP-1m9N0t196B-00gsP1; Sat, 20
 Nov 2021 00:18:08 +0100
Message-ID: <bdd54670-2995-9865-a016-2766a9f098a5@gmx.de>
Date:   Sat, 20 Nov 2021 00:18:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: de-DE
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: RE: [PATCH 5.15 00/20] 5.15.4-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RfJPnCLnZn51KWyapFe0pefSmVpL9+2eDGn9JwPB6zOhFhreCav
 29nm5SK6doKFbKiVyFIzvgHtlMkDCG116t7A7DcrQlzKWLfzXTi+/POkFbCPCMCNcBqxEo8
 F+fGVXSQ0KLGkcgzpQhvqTFjnqS/89X5AeIjHlrwCbu+eWR6+N25sMUA3ZOVdr+vpp5CFOd
 B50PjP8x3PPM97ojfhEUA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZQCa1wh6ypI=:+3BUTvfaW38CFZp1pM/nr9
 fQK58gPA/pAhtJRhAB7pL8w2wxC39iwWMn9q7/6bwSizqu0qN4/fV2ZMCF1Tz6+/7rxZ1W7of
 WuIVC0fh0O4QRg2pm5pG6NbzoJzKyx5fW2yD14SuB4Topa0YB9Zuz0CvE5SzHAXTyNNb3QIZm
 6wwOcWdwAxcXShtwLXnnxW980RWGE9wLnjGjaWfY2c1XUzO+ij1hIXLjb7PCK6oq8tLqkg1j7
 1STCSnC1g5IyvxzKkmaMVyS8Wp5vPfV+Bs67/ko03nLZHYjgbjYbgXha+dDyWOiruDMa541l4
 4Hvm4+oadxCeQ32KVeOEaQrj/zFLMfLxSdEePBDGc15twdHc2RJoCYy1X0ALZJCKP1VsC+Ioe
 Q3eNX/yARDJZHlgg0CGpp6VK00UUBjd0JJy0HOkIf7TFIg/oEW+NO3GkXHW4DtqfH8Pi6fBkC
 QXJIMYoAqImAJXddVI9MOZSDu8ks5d8W8DNMug2pC6uRaaRzNXemdQ3rJZkQxivVycDhsHkuA
 OVolJN0QVR83zMM6zIa/sIJOikvT8A7baCc/CDSKNZShhcbqkxN4IxiV1CVuCs7aqE18I6Kv3
 938rIjd8DloRdS88OH46p4bxHKxtj+CA2CcjNjUoKxYSvCsJCHjbuZRij+lMtNPNUH54i30Bo
 e9Al3LD7btCVbo0i9LNIZgiUWS8YNIn8i0vx/3UenX64Ym4za1Dv3+Q+sFuKgpadossPxVz1q
 WXGffrikHPrWI0laBzyfENCHsABaNI+7sw064fl7VfUt5m1EBHcJ2mojIDIL3jsnZXSEDTK5N
 FgoUMfiIYi0JRl/W48XgvxU8afO4QApi7xmHNqQEq/tAIj6PZwsFSYCyO5UlnUbgi/bHmBEgS
 CyAd4ghexykUzxI6b26o8yiAzXVw88IV4s1hLH8tRICtCINt7i3arOR2RIrCUlFAfig7ql0+J
 6QP8KuIBHwZeUFOdzXVKDaFLE3KoM/+dEbSkhrBbq8KxqSiGEjjK1cZZQalLmCb8rUcqMFbcz
 z5kAMLMJvlgoC+SX5JTM8/3mIZ9LcbqngqWUacss3XT75wdMRfjUlP2mBG1gM45aa0UXgAEZt
 ciCfVJguqJUA0k=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo

5.15.4-rc1 Successfully compiled, booted and suspended on x86_64
(Fedora 35, Intel i5-11400)

thanks and regards
Ronald Warsow

