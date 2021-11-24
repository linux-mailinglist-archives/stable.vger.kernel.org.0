Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E7D45CD89
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 20:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhKXT4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 14:56:09 -0500
Received: from mout.gmx.net ([212.227.15.19]:57225 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235076AbhKXT4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 14:56:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637783576;
        bh=1MgjXryvvcHtlBLw47QBpz3H8+bnkwc95Zb1Fww1ihs=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=CGrdhwTsaKJmvPfoq42Q4UjN+3W0b2MaoEWrzoO45NbNXEtEcu+1RysWtcXsMfjGA
         R636XbzLQZ5nj6rHJYZPhCVMYQAnLF63rjroLejZ8esiX3lB0+ZZq3X+/+q8eoZPCw
         3cAgNSW64d3FUhzcHWFwxObKHLq7c80NsM2/F18s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.115]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4hzZ-1mfluR1TpX-011g6O; Wed, 24
 Nov 2021 20:52:56 +0100
Message-ID: <a6cf8e9b-55e3-e07a-aefe-d1e2303941a5@gmx.de>
Date:   Wed, 24 Nov 2021 20:52:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: de-DE
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: RE: [PATCH 5.15 000/279] 5.15.5-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:q2U55BEm8S2TNwpV6ThtuC6j29WfOVGkFQgiul8goGF6UvSb5M+
 oithjpY1kauCW75A4iFIb+7BEDFhLvxT1Y0YN9m/JhvOMbNPY4YJyTnRhYnU+iVA2R/04oQ
 YlZPUpLnVEDFIrc6s3qTBauTWfyUmoqdbtiX1cHvEoxcx5oWjnlEYvE8ry2klwLPli6TbW3
 fhFi2h0jDYcepS3wPZiig==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Es2JwGx1k4A=:ShIazZ4d5tj0BvJcyQoAVJ
 7/i/+57c0jzjhltU5WDpJgC22Ja0pax8KII1X/dmXOUMGTNVtHwWbXAeK4YsuktXGYtmV1hLj
 zud9cGCSN4Roma/zgS07czqG14kQC1VbEkCyVC0LMmnXr3ATrZJlgtcvoUlo9uoPbLvfHz+JC
 1ym0PO6MabnESGaOa8WTkOnO2W7QUAoohz+NGB8vZaQyaXIeV23z27GItGbaxpF3MHbHh46Zk
 IPpdLgl4PI7bJZ7XZ5/0lrv56gbpJwvsPsBTWJIHYsy+BEP+GUl4KLEQ0FYC/PR3cLEHwcHC2
 L44VCrIYwdzETd4Kh1+AV7/IivCkGcK8K4C0yu5VVVv/qCKcw9/gnvQss9Jzg2NIa4942nF7K
 svWqPuJfoHt94rQO2jsz8DE+EOyuowOYHPdD0kc0r+QhcawOcPo3X4EeC7cjDwffGqazDUsrN
 hcdxxo6b5Y/INQ2tQt9I6+CAFkWXtS9ywUWZivJVSCK5Ino0dDFuChKj9rDAo8IdwWk2U+77x
 OtgtD1bBJRIDlc5qh84qVqdeGQ3sbCyE2LdSPu4Y1TufrBpopwgxp/Olim85sMUbtgASl0/ez
 1/vzLwsioADYovdrDgCBlKaAG9ZtSBfyJKXgoM6iCkJbQyeo8gv/sdNGdPJahs9DwzpCz6Wka
 UPGIDCmUfQzjYgXxJQcqy3f5DIuvnOu4q0O36zLbyHwAEil3e6Oh6NoEEbD28iZMkIqdIefsg
 DSybYyMwrL7AV20pipGVMjfo57somScjqtnqDZq98YPz7lpH46rvxHm7NPNNiwEG0N164fuNU
 FQvg7Odq3Ze5nQWSt5RbnQm/Em3W5x9+eXbK9hmG7TGLg5MrXACHJPgq3Hky9CF6He8nse3Gy
 9iTtplRRksHEIwTWq5jb5vhYGjQso/o51/jG4VBy3QiC3YbJ+Qa3KrXEnq/igeuz2TBvL7bAi
 j8gJ4SM1g7wm6Ehi9S54Dpyf3Y1l24vztaAxURbEfr7wrok1KfD8iDdlt9UKVbkZ94CrIoYMr
 YK9ApKmVebfFr3Z8DuIYtEvjVxMRG9av+djI91geEkB2YTWEuB9M3nzIy/AYWgA7yq/46aVA2
 48uBiWQLHj9BPQ=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.15.5-rc1 Successfully Compiled, booted and suspended on an x86_64
(Intel i5-11400)

thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
