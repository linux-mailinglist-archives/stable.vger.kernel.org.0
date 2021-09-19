Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B1C410C72
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 18:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhISQ44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 12:56:56 -0400
Received: from mout.gmx.net ([212.227.17.21]:36641 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhISQ4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Sep 2021 12:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632070518;
        bh=MMjrYu/zC7Tgi67XG7i4Dm419Zv7v9Inp7LxkDjjX/w=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=DkwHJaaVFqu5rESo+sH1qvuYPxMFWRG7vl/8RfB2alF/owr6TzUeHyFSFx/rDP5E9
         ZcB92nB5ShpQjzSh7//hJVU8wZDIoBwj0w4DeDRBbfnuU40V0q2Yb9JfKFIjiYZHIw
         EzgNKCb29BJMtZn9CyO2PvD18rcBIDzydHmyPsGE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.221.150.46]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MrQEx-1nCauH2KhD-00oYTx; Sun, 19
 Sep 2021 18:55:18 +0200
Message-ID: <4422257385dbee913eb5270bda5fded7fbb993ab.camel@gmx.de>
Subject: Re: [tip: x86/urgent] x86/setup: Call early_reserve_memory() earlier
From:   Mike Galbraith <efault@gmx.de>
To:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Cc:     marmarek@invisiblethingslab.com, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org,
        x86@kernel.org
Date:   Sun, 19 Sep 2021 18:55:16 +0200
In-Reply-To: <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
References: <20210914094108.22482-1-jgross@suse.com>
         <163178944634.25758.17304720937855121489.tip-bot2@tip-bot2>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jKWpV1XWSTfXOn5OtO2QUBKJ0HZL8CyoQHP6lCtVD7cUs8QOBUJ
 sMUh/SRsYtFjo7u2udyDpG2KmIU67K7PfN83tc+ApAPM3UNZBmgIsel9o1FdYQfltdsB8zB
 GgMTXTHatsSkfe1t5YEzKkKADS59+MfYqMhBfI6CALLyXa1Z7L5yYWdTkRwg+mvN7f8uVT8
 Wi8sNbt3lXPPiiou0QC1g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:m/ovrb63xIM=:4irSzwqq5t+bK5sI2Do5PF
 ZSj2BXASzqfcN6qZQ50psenHOvtAkSyy+RXMxACXNkOdiIwyGC2JbQcHaQ9ulDZasOB33X6Zg
 4KJ0tWp2cUrcPEvZSRraGtC9ICM3PmfzQ8w6045UJD5Injtv/TxZkBQI4ur+JLfpQne8B+noK
 /tPDJGi50XtyYceRHDuKHOZTKbSbfFV60wyWEUu+A43zbRIqscyuDcOz4Y88JaJHiFmHDMpSO
 xywDPLlgqPYUhSptNdt56ml0gaBF0ExXIFpLy3sYVCRUm3S3lBEQ+94RN5hQKR5gfTba5c7QS
 5x4z/yrfx7YatbDWNrLhAy6oc6D2JeHE8zIXfBD6xztroIKX6oEvrcZilgUBuaBIx2/H5XdWb
 yncEkgLtoVf3Yj5H1m9HtUl1TYnyz3sXe0p8Vi91jS1JB2ZBbDNAEA2/y5V8AG4WcqxQJYyLJ
 W4jb/j7Kkae6Aye6+Lt3mTACfU/xSXCiz7DA+4etSbuLfVLMwmoCIZW/TgrIivVw9Fjh110kB
 qiW/GEyPodu/A+/bTvsfwvDcZ39r9FHBRcanvbrHJDis1C09dD5tVQ2ApIiyCFV64rcl6Oqng
 cml+L2uGyi+0PzkuhEN/8v5NljbOhLeFqe2ytg8jIvVXo/qX1GtT7zMcirRHtiLdjRtGJWGaA
 GuPyhA5TJf2Lic3EtitLSJu9TRzcDuW51e8VZcE1kv8rjI7hJGok4NvAhdZc/NIQnxojiXJr9
 Ipxcbs3cWaWfPT2SsDfNfv3OYIbWhwxt77qgzs2Yb8mdnH94VktPebRIIwZ4IltsUc0T/1Rfk
 0aZQgCQmoTq9u6MXxIPUx4j/ZJJQeDGxHxaQa78OzGs1lrc1W6idyt8rYb78oDc/z/nQDj6Kx
 JiCNoJbUi0w11OdcKqsCtBlvkOsb7JBeLOK4OfIQu3kfetqrCRghkr2MWonCP4R0Ds0WeomV4
 UA8s324U270Drsym0IEzQ519IwdevZNby7uWzAeBMFBbW+qh21iG6GmC4USJ2M/kOnwVga9At
 eq9dNDPlbsbK2LWx2LkZDLEWycxr0x7pdYQixWAESD/sl8nQhg8eXqqtzb2CmZ4Y9eZKNBU7I
 TZlC6lbvVhXud0=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-09-16 at 10:50 +0000, tip-bot2 for Juergen Gross wrote:
> The following commit has been merged into the x86/urgent branch of
> tip:
>
> Commit-ID:=C2=A0=C2=A0=C2=A0=C2=A0 1c1046581f1a3809e075669a3df0191869d96=
dd1
> Gitweb:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> https://git.kernel.org/tip/1c1046581f1a3809e075669a3df0191869d96dd1
> Author:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Juergen Gross <jgross@=
suse.com>
> AuthorDate:=C2=A0=C2=A0=C2=A0 Tue, 14 Sep 2021 11:41:08 +02:00
> Committer:=C2=A0=C2=A0=C2=A0=C2=A0 Borislav Petkov <bp@suse.de>
> CommitterDate: Thu, 16 Sep 2021 12:38:05 +02:00
>
> x86/setup: Call early_reserve_memory() earlier

This commit rendered tip toxic to my i4790 desktop box and i5-6200U
lappy.  Boot for both is instantly over without so much as a twitch.

Post bisect revert made both all better.


	-Mike
