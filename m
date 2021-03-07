Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC8C3301DE
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 15:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhCGOKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 09:10:51 -0500
Received: from mout.gmx.net ([212.227.17.20]:35983 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhCGOKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 09:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615126249;
        bh=Z45+D5PbHnVrc/m7w8/Bo2jf74YJod722T5v15thi2M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=VKNj3Kq49mgPlsxqLgnVi0srOUbqOaRtYc1g18u2b7d/FXqW6uep0A/ioBBcD16KR
         ZUto+JSlNFmMl73eWjntVypNoWCzRnD5h7G3IW4+M4jBzkJVC/frB1l57Uow4pFdZO
         nE/nh9JlnWBmwsnLqbKo2xNX0R2xvXfv/VpbV+K8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.7.203]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MysW2-1lfE6731n8-00vxdE; Sun, 07
 Mar 2021 15:10:49 +0100
From:   Ronald Warsow <rwarsow@gmx.de>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: stable kernel checksumming fails
Message-ID: <d58ab27a-78ad-1119-79ac-2a1fbcd3527a@gmx.de>
Date:   Sun, 7 Mar 2021 15:10:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RDrB+4iW+Abk74MxqtbD96GPd6fFAouBMml9RqPqUfJkfJiYmor
 QUhe87oZsqmrVO+NfQwqn83Ez1BUqAbtiKGRhHgaVPx6pVXWEfhCLao0blJ1ul1TDW5Lca+
 wB4t0XpW2Mt8XFyR/H6Dkyb6vgJL8czbYfUs35xdD7IHE/NJDjjqSO4JrzqhmhSzs/RY6aK
 uaq4tLxq+79dCdJr8Rxpw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xPcCmNO+9wE=:q2oATNRsNVlqC5Gk2FMV/o
 WFl04iaEvQiBly8+zbCeD/E+iLFGW1o0ttXjzOQ1YI9uKiBnUUJy4vKinLCG5ets9zRs4jj6Z
 hEU5aLSX/9doAR5HG/mgzn8qAg3BsMOkSUA2OFn2xC0KGR/ALEUw1gvyu8Jni+Koo/abiJOGq
 3mPM1N6+f5VHePus0/rLZynCvwg2RqfIYH26sbok4QlPRO9xZZIJPbjv1n0AGOByZTy1t0UDS
 Mjd5+j4xsDvvSQWjWvfujHqC9skdMn94d442cGLH5ZHwNERKSLTsTaSC0YfT8mzlyAjc61ZiH
 G5iOGHvPCshJyLI636YQ6gs5ccvfrbK32Q5UvUkKk/onDpjrcgjmVFEjgV6ZQzkWF+u4BhGtq
 IbAc/AWE1lvuo8fWJP0xXVWHL1QLdQD5iIDG5Hjy0KXZChvCCG1NZJiy2DRN4EIFkzLd9YgzC
 O60rO/TRfqjsFeDHTBwIb84OHOX5pXhAdlCj8gyRM8RDNjT7T5EQpqrsjrG8nzSA7nRO6YM4D
 phKpJO3xtcmMUI+mtnCe3zjQEzyPM2Gub/cX7Rj/cXeWC7mi434IxXEdm4bAjiCL2I4340Bj4
 9bJBebaUyASV1GjN+Ckee7wLEazVD9tF30+DpHGRr2GDV7zA982/UfBtPq3t6Ju5ZmB1QwqcH
 Z8frKaG0bNtStalTXjkeTYLTOlNZ950tL45t+VS9qFsWlgE8cKFotUJ+D2uFb80yT5QRtf3VC
 qhXzOgNxLft04Uv80qaSuFaJVfNtRQEOuzrC+IC7QWgOuLK6gJffnGm94hAl2UdWuw1Cuf9X2
 IdDwUUGDXP9K+4A7nd7q5ZCCY5JJOaVhMswnDpNkauhZJyCZ+ToHIUSEUpVgoRZDJBgwX+lES
 qz2wmwdnT9ugFZnQM8SQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello

getting stable kernels with this script:

https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tr=
ee/get-verified-tarball


fails since the last 2 (?) stable releases with (last lines):

...

+ /usr/bin/curl -L -o
/home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/linux-5.11.4.=
tar.xz
https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.4.tar.xz
   % Total    % Received % Xferd  Average Speed   Time    Time     Time
Current
                                  Dload  Upload   Total   Spent    Left
Speed
100  112M  100  112M    0     0  5757k      0  0:00:19  0:00:19 --:--:--
5938k

pushd ${TMPDIR} >/dev/null
+ pushd /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted
echo "Verifying checksum on linux-${VER}.tar.xz"
+ echo 'Verifying checksum on linux-5.11.4.tar.xz'
Verifying checksum on linux-5.11.4.tar.xz
if ! ${SHA256SUMBIN} -c ${SHACHECK}; then
     echo "FAILED to verify the downloaded tarball checksum"
     popd >/dev/null
     rm -rf ${TMPDIR}
     exit 1
fi
+ /usr/bin/sha256sum -c
/home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/sha256sums.tx=
t
/usr/bin/sha256sum:
/home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted/sha256sums.tx=
t:
no properly formatted SHA256 checksum lines found
+ echo 'FAILED to verify the downloaded tarball checksum'
FAILED to verify the downloaded tarball checksum
+ popd
+ rm -rf /home/ron/Downloads/linux-tarball-verify.1GiZid5WT.untrusted
+ exit 1


checksumming the downloaded kernel manually gives an "Okay" though.


is this just me (on Fedora 33) ?


=2D-
regards

Ronald
