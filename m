Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31ED76BE7D4
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 12:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCQLS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 07:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCQLS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 07:18:56 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5DB7389D
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 04:18:53 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20230317111850euoutp025036b5e87c50a5c67009ecab3465c8ed~NMNWaLLLn1319813198euoutp02D
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 11:18:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20230317111850euoutp025036b5e87c50a5c67009ecab3465c8ed~NMNWaLLLn1319813198euoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1679051930;
        bh=SZ/CYlaxiDIHU6OYfGgK+7VueV1TvxtyA/Eb4yW6drk=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=g9d4AM5be1l9CfHLJLc6G7NcPbSCWeB0DWX1jwKnxpULwQqfm0b0vEaqB1pRH465r
         4her56Ttdi9dG2EEhFOthDHO3T3D2GEe26fLvf0AvSXTDdPG80vIMLa07BzAeytFJX
         +99Ol+VwdtZ0LL8/Cl/fkWndvm3FX9n6GvKnQfhc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20230317111849eucas1p1a2bd8f6f225b87ef2ddcf558345124cb~NMNWHa7oa2049120491eucas1p1N;
        Fri, 17 Mar 2023 11:18:49 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 42.6E.09503.99C44146; Fri, 17
        Mar 2023 11:18:49 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288~NMNVvlQbH2045120451eucas1p1U;
        Fri, 17 Mar 2023 11:18:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230317111849eusmtrp21e1167306c2776f58dc6831bac69db59~NMNVu4SSs3139831398eusmtrp2g;
        Fri, 17 Mar 2023 11:18:49 +0000 (GMT)
X-AuditID: cbfec7f2-e8fff7000000251f-ad-64144c994b61
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 90.6D.09583.99C44146; Fri, 17
        Mar 2023 11:18:49 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230317111849eusmtip2ed14adb4cbdd571c735cab92abb5b944~NMNVkQ8F93119231192eusmtip2-;
        Fri, 17 Mar 2023 11:18:49 +0000 (GMT)
Received: from localhost (106.110.32.140) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Fri, 17 Mar 2023 11:18:47 +0000
Date:   Fri, 17 Mar 2023 12:10:31 +0100
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <javier.gonz@samsung.com>, <k.jensen@samsung.com>,
        <jh.i.park@samsung.com>, <p.raghav@samsung.com>
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Message-ID: <20230317111031.lygazqsaeekpdegd@blixen>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <930CF361-37C2-4625-B5FA-245248544F92@oracle.com>
X-Originating-IP: [106.110.32.140]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWy7djPc7ozfURSDPau1bL4v+cYm8XK1UeZ
        LCYdusZocXnXHDaL+cueslssXX6M2WLd6/csFgs2PmJ04PCY2PyO3eP8vY0sHptWdbJ5bF5S
        77H7ZgObx8ent1g8Pm+SC2CP4rJJSc3JLEst0rdL4MpouXObqeATT8W5S7tYGxj3c3UxcnJI
        CJhInGl/wdLFyMUhJLCCUaKx6y2U84VR4sfyblYI5zOjxIS9zxlhWs7eXcACYgsJLAdqeV4D
        VzT3bxMThLOFUaLv30KwKhYBVYnOBWeBRnFwsAloSTR2soOERQSsJJ6fuM8GUs8sMJ1Z4uC3
        5WAbhAUCJGbcussMYvMCbXvYN4UNwhaUODnzCQvIHGYBTYn1u/QhTGmJ5f84QCqYBeQlmrfO
        BuvkFLCTuHTyPSvEzUoSDZvPsEDYtRKnttwCO1NCoJtT4vvjl0wQCReJDZfeQj0pLPHq+BZ2
        CFtG4v/O+VA11RJPb/xmhmhuYZTo37meDeQICQFrib4zORA1jhJPd35ggQjzSdx4KwhxG5/E
        pG3TmSHCvBIdbUITGFVmIflrFsJfsxD+moXkrwWMLKsYxVNLi3PTU4sN81LL9YoTc4tL89L1
        kvNzNzECU9Ppf8c/7WCc++qj3iFGJg7GQ4wSHMxKIry8P4VThHhTEiurUovy44tKc1KLDzFK
        c7AoifNq255MFhJITyxJzU5NLUgtgskycXBKNTAt+t2ysVaodtW0J0lXP0ttL3r/6Slfu/ta
        I4fsvo/e6kwuZX90fMuYXLQUnN/X372mMddhnW0qq+fTa7E21XZ7L5+6JnlDTOQ/S06Fps0y
        Cw/JB7e4GIQ+d8ydPiVcISqfwUlhB8vefqnynjJ/Q5G0Lznis3S/Of7ZMD/yEedtn7XJM26p
        BJ+W2rGt9adAfipvby0H56aAnb+jrZx68sxaYvaq7oyQ1heaqPdpWfanSdztDDk6tX+U52z5
        bTrVeuNryVe+i84YbDa4MSk1kC9dIjTsye6LD9csTIhZ+ayJ/0yejZtaU1T1Vsbjv0u+Cave
        2m/U/Gt5V/m5STcmyVRp1GsdOdFx33Bz1OIWIyWW4oxEQy3mouJEAJ3+J7y8AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t/xe7ozfURSDGY0Clj833OMzWLl6qNM
        FpMOXWO0uLxrDpvF/GVP2S2WLj/GbLHu9XsWiwUbHzE6cHhMbH7H7nH+3kYWj02rOtk8Ni+p
        99h9s4HN4+PTWywenzfJBbBH6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp
        29mkpOZklqUW6dsl6GW03LnNVPCJp+LcpV2sDYz7uboYOTkkBEwkzt5dwNLFyMUhJLCUUaL5
        2jQmiISMxKcrH9khbGGJP9e62CCKPjJKTGjfywThbGGUWPzhBFgHi4CqROeCs6xdjBwcbAJa
        Eo2dYM0iAlYSz0/cB2tmFpjOLHHw23JGkISwgJ9ES08zmM0LdMbDvilQG2YzSnxq2c0KkRCU
        ODnzCQvIUGYBTYn1u/QhTGmJ5f84QCqYBeQlmrfOZgaxOQXsJC6dfM8KcbSSRMPmMywQdq3E
        57/PGCcwisxCMnQWwtBZCENnIRm6gJFlFaNIamlxbnpusZFecWJucWleul5yfu4mRmD0bjv2
        c8sOxpWvPuodYmTiYDzEKMHBrCTCy/tTOEWINyWxsiq1KD++qDQntfgQoykwgCYyS4km5wPT
        R15JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6YklqdmpqQWoRTB8TB6dUA1PYyXVxDI1Han3/
        yU015FOdeWsGX6P8+/At+1ROOR/WClxxwvrgpXsTFhce8FW/ni3aVLqsyHWZjHC18RT3RoF3
        rvET/dPWekwQNFwX1MA/waxm3vEt974xeC1/6s8ZfdeM2fXhFYtLwo+U04znL98v+ystyr4l
        6+6H2au617PveXC9a269tW262WbpSSmuCvwFv71VbR7/bkxyv7DDMrA8OJ3pZfoTlkP/vbWz
        9gjvU1r9ZF37I8lwSXuT3lOnrb4p897K339swfotf064BW7fs747KD+RIe/KrSifeeUJ2Rdq
        JqcpJUpmi3buPjLvssSVm6sOOnwKP7+LWdjIIf7RdJe0zWGxzx44v3HNeKTEUpyRaKjFXFSc
        CACvOIyzZwMAAA==
X-CMS-MailID: 20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288
X-Msg-Generator: CA
X-RootMTR: 20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
        <20230316051508.GA8520@lst.de>
        <930CF361-37C2-4625-B5FA-245248544F92@oracle.com>
        <CGME20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Saeed,
On Thu, Mar 16, 2023 at 09:31:38PM +0000, Saeed Mirzamohammadi wrote:
> eui64 values are not unique. Here is an example:
> namespace1
> nguid   : 36554630529000710025384500000001
> eui64   : 002538191100104a
> namespace2
> nguid   : 36554630529000710025384500000002
> eui64   : 002538191100104a
> namespace3
> nguid   : 36554630529000710025384500000003
> eui64   : 002538191100104a
> namespace4
> nguid   : 36554630529000710025384500000004
> eui64   : 002538191100104a
> 
> I haven’t yet contacted Samsung. Do you recommend any one to reach out to?

I am able to reproduce this error with a PM173X.

nvme id-ns:
root@missingno:~# nvme id-ns -n 1 /dev/nvme1 | grep eui64
eui64   : 00253891010005b3
root@missingno:~# nvme id-ns -n 2 /dev/nvme1 | grep eui64
eui64   : 00253891010005b3
root@missingno:~# nvme id-ns -n 3 /dev/nvme1 | grep eui64
eui64   : 00253891010005b3

dmesg:
[174690.305507] nvme nvme1: identifiers changed for nsid 1
[174878.481002] nvme nvme1: rescanning namespaces.
[174878.535981] nvme nvme1: duplicate IDs in subsystem for nsid 2
[174878.599982] nvme nvme1: duplicate IDs in subsystem for nsid 2
[174883.673001] nvme nvme1: rescanning namespaces.
[174883.740045] nvme nvme1: duplicate IDs in subsystem for nsid 2
[174883.784025] nvme nvme1: duplicate IDs in subsystem for nsid 3
[174883.852034] nvme nvme1: duplicate IDs in subsystem for nsid 2
[174883.892040] nvme nvme1: duplicate IDs in subsystem for nsid 3

I will report this to our firmware team. Meanwhile, Could you paste your
output id-ctrl output here? I am interested in the fw version you are using.

--
Pankaj
