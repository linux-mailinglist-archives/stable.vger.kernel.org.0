Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FAB395549
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 08:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhEaGQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 02:16:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31139 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhEaGQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 02:16:05 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210531061423epoutp04c63aa1ea935fd4a60fdb12e0f83a0af2~EEhjf8TSW2173021730epoutp04L
        for <stable@vger.kernel.org>; Mon, 31 May 2021 06:14:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210531061423epoutp04c63aa1ea935fd4a60fdb12e0f83a0af2~EEhjf8TSW2173021730epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622441663;
        bh=MvGY/cvWmih4MHANNc0xl3aDaMBqgAMQl4fIBc9jNl0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=urH8UeIUO8oSLp/KFjZ3VSnO4K/1FADhIwOTNlVs6x4gUwMHdb5QSpRkgmw5SQbOo
         X2xvaBw9LpfRUX4nmfptrO2mWwmnH3wBAg2U/tfr0rAS4miolz8zJpUf4AjfyvFb0T
         2DpYYUXtjPtDabFuUG7siqbIjCcu+HR2bFev8/A0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210531061422epcas1p28ee4820c2481a9e46951143932ba0030~EEhifNMIe1694616946epcas1p2W;
        Mon, 31 May 2021 06:14:22 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.159]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FtlP95Wt0z4x9Pq; Mon, 31 May
        2021 06:14:21 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        7C.14.10258.DBE74B06; Mon, 31 May 2021 15:14:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210531061421epcas1p499e46c8a7609ee5e74eb4eca4603b8aa~EEhhDH8Ye0486404864epcas1p4v;
        Mon, 31 May 2021 06:14:21 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210531061421epsmtrp1b50fdaa52ca6d793d52aa3800d5e27f8~EEhhCdb5i3257532575epsmtrp1h;
        Mon, 31 May 2021 06:14:21 +0000 (GMT)
X-AuditID: b6c32a38-42fff70000002812-a2-60b47ebd6c83
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.E5.08163.CBE74B06; Mon, 31 May 2021 15:14:21 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210531061420epsmtip1ff6391b71e2cbbacfe912139b03ba228~EEhg1GsSm1374613746epsmtip1L;
        Mon, 31 May 2021 06:14:20 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Aidan MacDonald'" <amachronic@protonmail.com>
Cc:     <stable@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sj1557.seo@samsung.com>
In-Reply-To: <WCLW4rMlL5bsun3xz4lbVpKFcjJnaWwoKKvl-QPTF1YEaDtDX5uS3Pj472UxXuxgBnDbznfc0MpYj5fsCzLuhnbStgEN7jHv8Q_Ynxy3kFk=@protonmail.com>
Subject: RE: exFAT unexpected handling of filenames ending with dots
Date:   Mon, 31 May 2021 15:14:20 +0900
Message-ID: <003b01d755e4$31fb0d80$95f12880$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQCDCphTA+rnOBGAdGmRziAJCtGVAQCCc48mraFXBaA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdlhTV3dv3ZYEg2sdOhY7V65gttiz9ySL
        xeVdc9gstvw7wmqxYOMjRgdWj562TUwefVtWMXp83iQXwByVY5ORmpiSWqSQmpecn5KZl26r
        5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb2dTlF9akqqQ
        kV9cYquUWpCSU2BoUKBXnJhbXJqXrpecn2tlaGBgZApUmZCTsWjGI7aCaWoVd8/lNDBel+ti
        5OSQEDCRmPZyG1sXIxeHkMAORolrF4+wQzifGCX2TH/HDOF8ZpT4cW8vkMMB1rLvcz5It5DA
        LkaJE5MiIWpeMEqc37mVDSTBJqAr8e/PfjaQehEBY4mpp1lAwswClRJPFzWzgticAl2MElce
        ZIHYwgIuEm0zljOC2CwCqhJrP3aD1fAKWEpMWjaREcIWlDg58wnUHHmJ7W/nMEN8oCDx8+ky
        sHoRASuJp8u2MkPUiEjM7mwDu19C4Ce7xJq9a1ggGlwkTu+/C2ULS7w6voUdwpaSeNnfBmWX
        S5w4+YsJwq6R2DBvHzvE78YSPS9KQExmAU2J9bv0ISoUJXb+nssIsZZP4t3XHlaIal6JjjYh
        iBJVib5Lh6EGSkt0tX9gn8CoNAvJY7OQPDYLyQOzEJYtYGRZxSiWWlCcm55abFhgghzRmxjB
        SVHLYgfj3Lcf9A4xMnEwHmKU4GBWEuE9U7ExQYg3JbGyKrUoP76oNCe1+BCjKTCoJzJLiSbn
        A9NyXkm8oamRsbGxhYmZuZmpsZI4b7pzdYKQQHpiSWp2ampBahFMHxMHp1QDU9OvDo75Zj0T
        +y4oqcx+ztZVOOuaWtSuZxY9RwOC96foKkyb9TPwRStbVtROWwfvyRvuF1y5LVg3xZdNn9FK
        kKvpTEN0FmPqhBkKR0pjH6RZdT03f8ll37RN7tixoKVzzC+vernwty6T/dVjKyvThbnlN6y/
        fL7EoeWiZKGTsGL2m0JNF1WbZc8q83x4JOV+7CpcyZJ8q+Zv3dPWz3VdCwOdIyKXvUhmkuSQ
        +RivuVM2ebKNkbrYxpbm8rI9G7WkasuWTZo14f3qF5cbN/Zf/TvxZ89tb4nq+q0XpY7Znprk
        m9sjpP7uo3jKdTarpcxTv677zJU652P7D71XnRvvPhNsUanVqLmUmKe25v5yJZbijERDLeai
        4kQA2pB6iRMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnO7eui0JBrdOM1nsXLmC2WLP3pMs
        Fpd3zWGz2PLvCKvFgo2PGB1YPXraNjF59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8aiGY/Y
        CqapVdw9l9PAeF2ui5GDQ0LARGLf5/wuRi4OIYEdjBKzFuxk6mLkBIpLSxw7cYYZokZY4vDh
        YoiaZ4wSb689ZwapYRPQlfj3Zz8bSI2IgLHE1NMsICazQK3E4o8cEOW3GSWOT5sENpJToItR
        4sqDLBBbWMBFom3GckYQm0VAVWLtx25WEJtXwFJi0rKJjBC2oMTJmU9YQGxmAW2JpzefQtny
        EtvfzmGGOFNB4ufTZWC9IgJWEk+XbWWGqBGRmN3ZxjyBUXgWklGzkIyahWTULCQtCxhZVjFK
        phYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBMeHltYOxj2rPugdYmTiYDzEKMHBrCTCe6Zi
        Y4IQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTM2tAvt0
        FoukHuk6sPrviQMvq56v0pvdrL/XJarHoO+0w7Of7xXfpUwStE2SFfrW4P1QrmBhvvCsxp0m
        L4S2SZyYFnfn4Df517KRRfNnCnCaqR193ZXfHZWe0dt98o5+7eG84M0SkfI7FJ3F9W+IF+/Y
        9msRX0OFU9wZZuHg5clnF0w22nvv39u95Szva4Q3nBIN7DY6nNHVxPHoFwsrt9g8jf3fkvw0
        p2Vwvj4dnO9uc0TAUqxpw9nKbyb5F27O9L/+q83dJPCmhxL//TqhGvnDX1T1M3heR00QiBUQ
        +DBRsfvgrUUyhcwBk2qNZeo9Lk2Kk2R9v0H+7uu6swsrzn1Y/KOsKuvRjCatWR9FlFiKMxIN
        tZiLihMB17M67/4CAAA=
X-CMS-MailID: 20210531061421epcas1p499e46c8a7609ee5e74eb4eca4603b8aa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210529011033epcas1p263d52006d4b27f33da6b81ef2c191db9
References: <CGME20210529011033epcas1p263d52006d4b27f33da6b81ef2c191db9@epcas1p2.samsung.com>
        <WCLW4rMlL5bsun3xz4lbVpKFcjJnaWwoKKvl-QPTF1YEaDtDX5uS3Pj472UxXuxgBnDbznfc0MpYj5fsCzLuhnbStgEN7jHv8Q_Ynxy3kFk=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Hi, Namjae and Sungjong,
Hi Aidan,
> 
> Recently, I was made aware of a problem with how the exFAT driver handles filenames ending with dots.
> 
> Original bug report was against an audio player supported by Rockbox:
> https://protect2.fireeye.com/v1/url?k=f989dd16-a612e473-f9885659-000babff32e3-
> 714879f4126cb358&q=1&e=493a850d-5944-4bc5-a1c0-
> 636611a9023d&u=https%3A%2F%2Fwww.rockbox.org%2Ftracker%2Ftask%2F13293
> 
> Upon further investigation it turned out to be a Linux kernel issue. Note the audio player referenced
> there runs Linux 3.10 or so and uses some version of the Samsung exFAT driver -- so I guess this has
> been an issue for a _long_ time. I was able to reproduce it on my laptop running v5.10.39!
> 
> It appears that any number of trailing dots are stripped from the end of the filename, causing some
> interesting bugs.
> 
> The behaviour I am observing is this:
> 
> 1. If creating a file, the name is stripped of all trailing dots and the stripped name is used to
> create the file (original name is silently discarded).
> 
> 2. If accessing a file within a directory, the stripped filename is used to conduct the search, ie. if
> you enter 'A...' the driver will actually search using the name 'A'.
> 
> It is this second part which causes problems. If you have a file named "A." on an exFAT filesystem, it
> will show up in directory listings but if you try to access it, you get 'file not found'. That is
> because the driver is actually looking for "A" even though you think you are looking for "A." -- and
> even worse, if "A" does exist, the driver will silently access "A" instead!
> 
> Clearly due to the first part, you cannot get into this situation without using another driver -- like
> the exFAT FUSE driver -- to create the problematic filenames. (That's how the Rockbox bug reporter
> managed to run into this.)
> 
> Now, a function called exfat_striptail_len() in fs/exfat/namei.c is responsible for the filename
> stripping, it simply removes all the trailing dots from a name and I guess it is the cause of this
> problem. So this 'feature' was intentionally added in.
> 
> I've only skimmed the exFAT spec but I can find nothing in it about stripping dots from the end of a
> filename. The FUSE-based exFAT driver appears to treat dots as significant too.
> 
> It seems Windows suffers the same trailing dots bug, silently accessing the wrong files despite
> listing all names correctly. But I obviously can't say whether that is due to filesystem drivers or
> issues higher up the stack.
We have seen the phrase on the exFAT specification below and checked Windows behavior, So we have
interpreted that exFAT also has same trailing period rule as described in the FAT specification.

#exFAT
The concatenated file name has the same set of illegal characters as other FAT-based file
systems (see Table 31).

#FAT
Long Directory Entries
Long names are limited to 255 characters, not including the trailing NUL. The total path length of a
long name cannot exceed 260 characters, including the trailing NUL. The characters may be any
combination of those defined for short names with the addition of the period (.) character used
multiple times within the long name. A space is also a valid character in a long name as it always has
been for a short name. However, in short names it typically is not used. The following six special
characters are now allowed in a long name. They are not legal in a short name.
+ , ; = [ ]
Embedded spaces within a long name are allowed. Leading and trailing spaces in a long name are
ignored.
Leading and embedded periods are allowed in a name and are stored in the long name. Trailing
periods are ignored.

> To be honest I have no idea what the purpose of this 'dot stripping' is... even if it was for the sake
> of "Windows compatibility" -- ie. mimicking Windows bugs -- there are names that Windows normally
> rejects which the in-kernel exFAT driver will accept, such as names with trailing spaces.
Let me check it. There was a code to strip names with trailing spaces before. But it was removed with some
reason. We need to check our history. If needed, We will add it again.
> 
> Personally, I don't see any issue with how the FUSE driver behaves. It also seems to be correct with
> respect to Microsoft's official spec. I don't see why Linux should deviate from the spec, especially
> in a way that makes it _less_ robust.
I think it is a problem of fuse-exfat, not Windows and kernel exfat. fuse-exfat allow to create file with
invalid name that is not recognized in Windows.
> 
> I did search for any other reports of this issue, but it seems to be such a corner case that nobody's
> mentioned it anywhere. Nor can I find any discussion or rationale for the dot stripping behaviour.
> 
> Kind regards,
> Aidan

