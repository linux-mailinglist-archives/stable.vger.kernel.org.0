Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1719342CDA
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408043AbfFLRAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 13:00:06 -0400
Received: from mout.gmx.net ([212.227.17.21]:33373 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbfFLRAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 13:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1560358804;
        bh=ooMD6bTUceH0+KjglBVTXtLS+8yTOQqJypoFeGSvpxA=;
        h=X-UI-Sender-Class:Date:From:To:Subject:Reply-To;
        b=O+lvvLfSh8gcLffPwkogkuRaNZ5f/IPY8SIlt8D/HRE8z4q2QTH5jj2Tt6MKAXU/b
         hyWukAqp1/IPATtmFiYBVnrIvFqZzaD4bRRnsnQBIAmAPbJD0ee9B85+vfnFgq0DQa
         mez7788kgfz9tvCbz2c27YXy/UI9D/Nm8KBiQ0i4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([88.152.119.181]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MD9uq-1hrZg82oAO-00GVZu for
 <stable@vger.kernel.org>; Wed, 12 Jun 2019 19:00:04 +0200
Received: from localhost (localhost [127.0.0.1])
        by localhost (Postfix) with ESMTP id 91B9B40BFF
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 18:50:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at 
Received: from localhost ([127.0.0.1])
        by localhost (inet.alex.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q33WoRkkgIzd for <stable@vger.kernel.org>;
        Wed, 12 Jun 2019 18:50:09 +0200 (CEST)
Received: from alexsommer.myftp.org (localhost [127.0.0.1])
        by localhost (Postfix) with ESMTP id 5F69C40B86
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 18:50:09 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 12 Jun 2019 18:50:09 +0200
From:   Alexander Sommer <alex@sommer-info.net>
To:     stable@vger.kernel.org
Subject: Betreff: crashed linux mdadm raid
Reply-To: alex@sommer-info.net
Mail-Reply-To: alex@sommer-info.net
Message-ID: <7ebdd1c4e0f955fa2b5bebc85547c975@sommer-info.net>
X-Sender: alex@sommer-info.net
User-Agent: Roundcube Webmail/1.3.4
X-Provags-ID: V03:K1:yoLWxg0ciVZH3U5WjXXGT7hsP+pNEuFStNhWiT+yRh9wKJtIFNn
 VOUQZWk+K0B7Vmb8s2VqD03mgsLb53Qx5LB7V0RuNfUQgkXJl8g7JoV2BhJ675OLxcpL6qI
 8MpgFHfmkWOcPsPMOJ6OXjnwd36dyXbHZKzR16zuYOIdC8WelMpEpYp5wOF3RxXZ2aHCiW3
 dLW+AaMagJcoQQ3iudRmg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:y1ph6NBuLT8=:0ifhsFjKgkwxP7nWT2+Y30
 QGszpITK5shqOka+7+FodxOQEjRqoIYCAoINP560AirviX50B2tiGAJfmmKqC/ELXTSfFMYhR
 nX2AO6q9+8ttjMJs0fhpubG1q/EqVZk3SLrg8FfD8T5b4l2So207a8myUfvEfEfBkn7ILGYIm
 imNAKZLh1dJopQOH2QeTBVCyC4XFr7fOr6zs+RkjqsRBK0jH8Jiqi6tkhze5JlnDs5n+H5NrV
 cfG4ydGpyj08j91JWS3Jj6CGDw5MW45b4P8+M2q4oMJDIZWjbtKrh1ur/cUI/f4yMJkVOi6Ek
 1t215c/SXNWIzLcWL6lJKyPTaFPN7lJmRY7eTSpqKUWtS6a878ea0VSutZzQI1usmu3AQuM5I
 866GpDeq0RD13UIagpoXlN8AtHJWShj1J4koSKjgy278dh/+6caKAiLOw5aXRbl3xcG26m80s
 A06tPLhrMDuNicaPHcu7sb4WQgocsNnD4VZEpPErKZv5AXJts0rsezjZtmGRgncHoBn5y+Qoz
 qeaDo3qCUguPJLnA5o3ypy+q+4buEpJj5/N5AEUiqkjwi+zQ4smYnO6G9wDlDn94fQ5eQX87A
 XJhwhHuIHZK9whfxdMjf9P+9axUHY8F3s3KHIsqvuZbbMxE80PM0T5uJopdJmRb34nj9RRYl6
 Sc0QMhiucTpd2AENtkd0zsXs6KyzjCTpCbIz9sAO9vlwBSt710tNpke4OCSl2+W0ljeszk45l
 V8An4Q9lfg6C0a6gHEZEGqzkWzILIoWlajC6j63aUHUJA9sRaYaC/RTJB9MG+TdrqSqVbL8C8
 lwAreUJh7pgitJlLXiciKkSJOpvSgQFdHTajrtCImxGBHjEOaVuV8adwa7Tu8Ljk7F0kqV+jk
 8Gm/akmo9VV3qOe2FN4wU7gjlGpOL3SnCAwh32ouCwx02bjmhaVQPjJ8y8DEEtarEc6jFnfcp
 osw/IED0499wraduXmcXOtmckYV3Vlnq6ZFgpdtoJ1xiOl1+sj9/T
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

after a problem with my external disk enclosure my md-raid is broken.

if I do an assemble I got this:
root@server:~ # mdadm --assemble /dev/md2 /dev/sd[lmnop]1
mdadm: /dev/md2 assembled from 2 drives - not enough to start the array.

I assume the broblem is that the disks events counter has different
states:

root@server:~ # mdadm --examine /dev/sd[lmpno]1 | egrep -e "/dev/sd" -e
"Raid Level" -e Events -e "Device Role" -e "Array State"
/dev/sdl1:
      Raid Level : raid5
          Events : 253626
    Device Role : Active device 0
    Array State : AA.AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
/dev/sdm1:
      Raid Level : raid5
          Events : 253626
    Device Role : Active device 1
    Array State : AA.AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
/dev/sdn1:
      Raid Level : raid5
          Events : 253618
    Device Role : Active device 2
    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
/dev/sdo1:
      Raid Level : raid5
          Events : 253618
    Device Role : Active device 3
    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
/dev/sdp1:
      Raid Level : raid5
          Events : 253618
    Device Role : Active device 4
    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

This raid is used for backup, I do rsync to this device and have for
every day on directory and I need some of the old data, so I need only a
way, to read some old files, and than it is no problem to clean the
disks and create it new. So I do not need the realy last state. If I got
the files which are some days old it will be ok, on this device normaly
I do not delete something, there come only new files and hardlinks to
the old ones.

So, do I have a chance to start it?

Gru=C3=9F Alex
