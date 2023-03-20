Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC86C1324
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCTNVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCTNVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:21:14 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44F11702
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:21:12 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20230320132108euoutp01cfbb926dcc5137c71a283782677ac425~OIz-gFlyo0994909949euoutp01N
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:21:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20230320132108euoutp01cfbb926dcc5137c71a283782677ac425~OIz-gFlyo0994909949euoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1679318468;
        bh=sbyqXqoXRMYqXTD1u3Ab+qOj/IRXNylcus7hLq1x6/U=;
        h=Date:Subject:To:CC:From:In-Reply-To:References:From;
        b=VkkHZADaiFdB+J+/RrZs5F+YQA7Wd/8KLY0uKBnW1TJhyaszNxERNnI99zKxhkjpi
         3ToeJaCf0ptArWhK2m3A8EQqTkyJ5GxVcJTd2nAE0FrW2YYp/9uyl5H+o9qlT1xUF0
         JzvacfiJZaYreJd4F1YC0uIYdm/XDSVOqNcbd1MU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20230320132108eucas1p2ebbe60c573a2b3aa2888a9da3b00a1a0~OIz-R5StE2025020250eucas1p2E;
        Mon, 20 Mar 2023 13:21:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 07.C7.10014.3CD58146; Mon, 20
        Mar 2023 13:21:07 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20230320132107eucas1p17f65ea0f0521391071fbf7d6fd0a093e~OIz_5a2qs0977709777eucas1p1J;
        Mon, 20 Mar 2023 13:21:07 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230320132107eusmtrp17ceec616cbfca188ba42365a81298c02~OIz_4qMJ10784907849eusmtrp1n;
        Mon, 20 Mar 2023 13:21:07 +0000 (GMT)
X-AuditID: cbfec7f5-b8bff7000000271e-e2-64185dc36e38
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 28.9E.09583.3CD58146; Mon, 20
        Mar 2023 13:21:07 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230320132107eusmtip2cf04c08eb20679c99ca1090804974bf4~OIz_qy3Xb0452204522eusmtip2S;
        Mon, 20 Mar 2023 13:21:07 +0000 (GMT)
Received: from [106.110.32.251] (106.110.32.251) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Mon, 20 Mar 2023 13:21:03 +0000
Message-ID: <160812bc-20b7-84f4-62e5-5ef4bc624c68@samsung.com>
Date:   Mon, 20 Mar 2023 14:21:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
        Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Content-Language: en-US
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "k.jensen@samsung.com" <k.jensen@samsung.com>,
        "jh.i.park@samsung.com" <jh.i.park@samsung.com>
From:   Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <3B7AB643-C87C-4C19-A47A-C15565750243@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [106.110.32.251]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUwTYRDl6y7tFi0uV5iAiilqAgaEKLURbRBFGxMTMGoEIVLpCihU7XJ5
        I/WIxQgCiVKVgnLJfVoQlaQgKBi8otJKAYV64QFB4g2yLhr+vXnz3nzzJh+B2ZZaOhHRijhK
        qZDFCLlW+PW2710erWEg9zL7iSdutnHF10rvcMQZ+mdI/OTGJa5YW2jmiQuK2jBxxdBnXJxb
        /Qr5EdJzqk886YPealxaU3KaK63NPyptMiRzpSNmIy4drZkbyAuxWiGnYqITKOViSbhVVOtV
        2HuCTHr3q4qXjAZnqhGfAHIpNGRpcTWyImzJYgT1rzqmii8I8l60YmwximDw9Tj+z5IyXIXY
        RhEC9VAq/l+l6TFw2aIJgaG/1pKxCEgJNJY9ncQEgZMLIE23maVt4F72IM7QDmQIvB1KYGg7
        MhAuGE0YgzHSEYyDWg6D7cnl8OZu39/xGNmBQXNmMmK8XNIdjp3mMRr+5Eta01fEet3ghO4n
        j8UuoKq/iLEBhHDzUQ5i8WEob7vPY2YCeZ4PXY8vTYnWgKniA4/FdvC+vW4Kz4bOzDNTlzgI
        5u6fGGs+jiCtsZLLLASkL5y9H8NqVoG5cRhnaWvo/mjD7mMNGdfPY+logWbaJTTTImumRdBM
        i5CL8BLkSMXTsZEUvURBJXrSslg6XhHpGbEntgZN/qfO8faxBlT8fsRTjzgE0iMgMKG9YC0G
        cluBXLb/AKXcs10ZH0PReuRM4EJHwaKV9yJsyUhZHLWbovZSyn9dDsF3Sub4OytCL1suC8vi
        o3KlM25THd1eWBZ25sdqr6YUcmEL1fBRmXNlXUvzgLHOqy4F1/bfyn7SR9SuGygoc4WEw6KT
        sx7PfljZq7rQnxY0Txvst7Gcltm4jM050hnkoEv/YTjVKzFaSpcPNIruWETJ7y5a7LM7vzYg
        2Dt1/4qQzs3qqg4so1QTYB3Y40EfKhrNzqkY19OxQiO1r0W+S5cX0TVxysJ1ieRFto8qKfTZ
        1pQjo4b0IFPU/DhBuPd6jcjhduTz4KVzLRIrNzWPze8hieGIhz3+ut/hKlHSjDRfkf3Tr9vM
        6g23vo24jbw8V7/Tzy2xb8dxU2YdHbBF4lqfGZogxOkombc7pqRlfwAMsTG9vgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t/xe7qHYyVSDM7tkLf4v+cYm8XK1UeZ
        LCYdusZocXnXHDaL+cueslssXX6M2WLd6/csFgs2PmJ04PCY2PyO3eP8vY0sHptWdbJ5bF5S
        77H7ZgObx8ent1g8Pm+SC2CP0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXS
        t7NJSc3JLEst0rdL0Ms4sliioFWg4uWfDewNjE94uhg5OSQETCSaPmxg7GLk4hASWMoosbFr
        KxNEQkbi05WP7BC2sMSfa11sEEUfGSVaXp5hBkkICexmlJj1xR7E5hWwk9i55iprFyMHB4uA
        qkT/9lCIsKDEyZlPWEBsUYEoiad3DoG1Cgv4SbT0NDOC2MwC4hK3nswH2ysiYCXx/MR9sF3M
        AqeYJfZPboC67hyTxIc39xlBFrAJaEk0doIdxwm0d/7d71CDNCVat/9mh7DlJZq3zmaGeEBJ
        Ys/FeYwQdq3Eq/u7GScwis5Cct8sJHfMQjJqFpJRCxhZVjGKpJYW56bnFhvpFSfmFpfmpesl
        5+duYgTG9bZjP7fsYFz56qPeIUYmDsZDjBIczEoivG7MEilCvCmJlVWpRfnxRaU5qcWHGE2B
        YTSRWUo0OR+YWPJK4g3NDEwNTcwsDUwtzYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGph2
        VDJyShTdvRn4/aWI0eSKhScmySe52vqzJyuqnzxZVdg71YPrwqN54ZsYM+67pNo9rb7Wl9Qn
        nv145ptA1l5Lozc8lxYXL1c8fGVGuJTWNfX1hz67flzG75hoXWhTzcWwskDVRzTS7Cjn+RWM
        T1YW9aXefLTt/dn7c2S7eT/Wm7GJqO4MVdkc7cjMY9354QOTpZfg5ZTw/xL23reuf67KDU34
        /Uhn8o+y7p/vTPq3/GowWDnDeMrDyQx7dxrPzJmlPEP28rsOm8P7Dh2f8eCLqMLRe+rG/l5l
        6h5Hbust881OWcVZ5LO3+6eO5aNqwTN8qxvm2G9Ldrmyqma9ecC+sIb3Rf/3cRn0zZjxYo0S
        S3FGoqEWc1FxIgB2BdwZdAMAAA==
X-CMS-MailID: 20230320132107eucas1p17f65ea0f0521391071fbf7d6fd0a093e
X-Msg-Generator: CA
X-RootMTR: 20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
        <20230316051508.GA8520@lst.de>
        <930CF361-37C2-4625-B5FA-245248544F92@oracle.com>
        <CGME20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288@eucas1p1.samsung.com>
        <20230317111031.lygazqsaeekpdegd@blixen>
        <3B7AB643-C87C-4C19-A47A-C15565750243@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-17 17:26, Saeed Mirzamohammadi wrote:
>> Hi Saeed,
>> On Thu, Mar 16, 2023 at 09:31:38PM +0000, Saeed Mirzamohammadi wrote:
>>> eui64 values are not unique. Here is an example:
>>> namespace1
>>> nguid   : 36554630529000710025384500000001
>>> eui64   : 002538191100104a
>>> namespace2
>>> nguid   : 36554630529000710025384500000002
>>> eui64   : 002538191100104a
>>> namespace3
>>> nguid   : 36554630529000710025384500000003
>>> eui64   : 002538191100104a
>>> namespace4
>>> nguid   : 36554630529000710025384500000004
>>> eui64   : 002538191100104a
>>>
>>> I haven’t yet contacted Samsung. Do you recommend any one to reach out to?
>>
>> I am able to reproduce this error with a PM173X.
>>
>> nvme id-ns:
>> root@missingno:~# nvme id-ns -n 1 /dev/nvme1 | grep eui64
>> eui64   : 00253891010005b3
>> root@missingno:~# nvme id-ns -n 2 /dev/nvme1 | grep eui64
>> eui64   : 00253891010005b3
>> root@missingno:~# nvme id-ns -n 3 /dev/nvme1 | grep eui64
>> eui64   : 00253891010005b3
>>
>> dmesg:
>> [174690.305507] nvme nvme1: identifiers changed for nsid 1
>> [174878.481002] nvme nvme1: rescanning namespaces.
>> [174878.535981] nvme nvme1: duplicate IDs in subsystem for nsid 2
>> [174878.599982] nvme nvme1: duplicate IDs in subsystem for nsid 2
>> [174883.673001] nvme nvme1: rescanning namespaces.
>> [174883.740045] nvme nvme1: duplicate IDs in subsystem for nsid 2
>> [174883.784025] nvme nvme1: duplicate IDs in subsystem for nsid 3
>> [174883.852034] nvme nvme1: duplicate IDs in subsystem for nsid 2
>> [174883.892040] nvme nvme1: duplicate IDs in subsystem for nsid 3
>>
>> I will report this to our firmware team. Meanwhile, Could you paste your
>> output id-ctrl output here? I am interested in the fw version you are using.
> 
> NVME Identify Controller:
> vid       : 0x144d
> ssvid     : 0x108e
> sn        : S64VNE0R602271
> mn        : SAMSUNG MZWLR3T8HBLS-00AU3
> fr        : MPK94R5Q

We have reported this error to our firmware team. I will keep you posted.

--
Pankaj
