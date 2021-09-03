Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086F13FFB8D
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 10:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbhICIHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 04:07:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50410 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234749AbhICIHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 04:07:48 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1836F6q4023057;
        Fri, 3 Sep 2021 08:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=w9iTg0Z7xNDBT8QU+HrcVVcoqCqX85SG+50lrjqmFSY=;
 b=mmvPb1hCKsf2PX3nKpF4b1JdtYIzqGRw1D+6Qf0LUW3ThA4w4l70DgCbYVSk+jlgA+cN
 FldPvHZo7ECGqRX5T60A0vkji4o/ld5uPf+C2Dqhomv9AK7qMwchwtYPPL8+uGmX6Y4V
 9+CHUnVqaYpynaiAZFFVrK+cnBOvGAmesKbtEbjjkrbjrc3PCOYPs9rDWIowDY6ZduRS
 Q7kGxc1uvnqWMzM7f1JO6U5VCaReDlW2VsALY8FZZoK0KG9W+62/ehp1IZBVLWAiKMjH
 zXI45GKvdZ1Pc3lqFNhkBCIWuohqt+aIvGJqVdM/ydi+fQ8MpLz3JJCbPtcH/Tx9VecD rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=w9iTg0Z7xNDBT8QU+HrcVVcoqCqX85SG+50lrjqmFSY=;
 b=qnXYzuT9tTOm3fAXhFVwksMKWXe19qI4En8Hz/0z4yVj75C+5z76JUEMWJKKciclvUfQ
 rK6xr+76nWt2SNUz7XT8jfNF7ipQc5/YT5JYoLRVp9nOa+BqaqRVk26QgD4mBIJVdesh
 Fg0C+382lLBcUgLWuvFslHsyC5pV3T4hk3MmuiUxvbwJ52ZfzEeMtQkxDZIW11iGMgXW
 R616wLzSNdSEZzFo77N3pHA8qf6HH27yU3W0x9zMotPIDNMHQN7xzc2cLKtgiJ84GE4F
 WMd9bZKT+kczkOtmr9jERiwEO1nbkj7eR9fNV5oy1xnew0SZvW45wJhEUfVwB0+3qVVw UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdvynhk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 08:06:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18380aYv132663;
        Fri, 3 Sep 2021 08:06:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3ate075dpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 08:06:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDRICu4fy0cePXLlitUkCEugcY/+x8dX/VeNpow1HRx88xNyJfBw4o1S2vYItPxzoMFXXXpfDTDAKdFbDE3I5dlePxu7TpsL2W56r4CfmMjO+TBJDfbJNqGLACBBSPNR4rSOWuBFuGAgmoUt7zbrHZeu7tjySrosfonHYTm9CmQqpxd/QCSV64XaQxJaF/XgHIwWn0tJRTb+3s+xfrqlO2OugW+EQYzEOP9tzM3tYgVKQgWleq7/aSeOaMTJZ6QwtGn9frWHqbBEf3ciQoKGsgrZGQ68CPmksrYiI8Xc3WY+YJC9aqrOd/rucyaQ8JBndYFzGVioaWnHb2M4K4j1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w9iTg0Z7xNDBT8QU+HrcVVcoqCqX85SG+50lrjqmFSY=;
 b=kfldGaROvn3g9yb7CFYxzB5/RjdlPDxvkYoy+XLV3NbaJvkALKpKmivC80yIiabUjKPdEM0fp8SXzAWXd1XOzqrcFAX8PHpj2kqALpwJt0pLRKhPNQx6E6G9aPJWj6jqe3DAWvut+ui85NIuX7xW0yN9cX0gjVLnU31J/f7Z9WgEpawxHb5Igk/PuWXVtDhoQuEnwqbw9sPi9oSNitLPMdNGs8sFKf5joc96iKIaaa+6jYpssmSw5wGvpzPuFD9ZXS7AhO0w2jYbmqmDMNPwJia09GBtlduwdaUBFgqIMyTCUVAx1yOhKoKy+oayEeIVezw/+uayjRToAOTor52dyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9iTg0Z7xNDBT8QU+HrcVVcoqCqX85SG+50lrjqmFSY=;
 b=0MAJlhhXlBDoDoJqmUuJIQuxwWl1a8tkQHVsaZNwvnKSE9C5NPmI8siJ5Q3tGeXHHgF6N0+oJfqp1YniifRXnMC5uDQU5dKc3/vr7nZQxpKbWuhkv1mE8YM6mUDzoAljR9K6eAPUoA1yF4XV8LITl28nNS1r3dc/GSRYk3687Ys=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1423.namprd10.prod.outlook.com
 (2603:10b6:300:23::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Fri, 3 Sep
 2021 08:06:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 08:06:37 +0000
Date:   Fri, 3 Sep 2021 11:06:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Todd Kjos <tkjos@google.com>
Cc:     Martijn Coenen <maco@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Martijn Coenen <maco@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] binder: make sure fd closes complete
Message-ID: <20210903080617.GA1957@kadam>
References: <20210830195146.587206-1-tkjos@google.com>
 <CAB0TPYFmUgPTONABLTJAdonK7fY7oqURKCpLp1-WqHLtyen7Zw@mail.gmail.com>
 <CAHRSSExONtUFu0Mb8uJeVKcyDYb8=1PO7a=aQ=DUEpA5kAcTQA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSExONtUFu0Mb8uJeVKcyDYb8=1PO7a=aQ=DUEpA5kAcTQA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0071.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::22)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0071.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 08:06:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95e501e6-9d42-458d-701b-08d96eb1c068
X-MS-TrafficTypeDiagnostic: MWHPR10MB1423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1423695BF56E66C3AFDEBB6C8ECF9@MWHPR10MB1423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7O6eWTnTNI3tnntQiJctMP23rvJaI1kZzNc4r5QzEaiYlJIqedbYU1VSREFsg3RyDidGFTtlfSM0LkR6zv5VKecVbHbwz8aWH43yiydOr2GvUz/meEp9J0LMCtP1WZppl+PsreYYSbOb2wETkwGA4A2DBl501VRtWkx0xui1OV2CChkLOZ4kbG0/wj9Yw/3wOC1IIcfXZoljt3FC5i+zz0Q2nMCc2izxI9dkAncC0oCd6Redd1vJ1DgpHHiEF0ocY0HCz7LLLj8GsiTc08wfzWFvgltdGC95BYiAfdAv7zAOKmq9iRaco2fHi8VDTItY95uJ2PMwhqh3XgfbO93M/7Qj/W5+eGAqrzt06Xw+ZVODk4M4Ce9HVecvwxhKErsdbZ4bHfTiCZyxuDNEUCX5mfAmI0vfjHj8geV5WbNu2zpP1Cdnrdx5/BTmpGqaNNpjiGBMGvZbDRNUDsKdcZ4VtbzzF8edJCLPopvB7vmFJHJ/wIZtmXgq9PzNmqL/Vps6Asub7JUY1/t1kWLgtAHoNjsFNzWGtVGCWBJoaFxxgP7eq9XFE3yI1Anu3/UTLkJ/XBiUXtUsNibf0I/oXLkbKO8o8xMe7WBN1IWyHOoTbwUIgKopCHCwKKig7DEvesSYqRUyqnLxLYF8rJvi+Bh/B5wTjxVqCikNpJhcKz++BGM4nWdMv0SaIiUgk4OfjhXmJbI70e7hRRD7op8tB/qqlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(136003)(396003)(6496006)(33656002)(7416002)(55016002)(52116002)(44832011)(9686003)(26005)(66476007)(66946007)(66556008)(53546011)(186003)(6916009)(5660300002)(1076003)(83380400001)(8676002)(956004)(2906002)(9576002)(316002)(8936002)(86362001)(4326008)(54906003)(38350700002)(33716001)(478600001)(6666004)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S+2Wa7ZB1iluy8ECeA4HqZ70q0Jf4zCJ/DDJltzRqm/1t4HGVrmTbE9BN+e4?=
 =?us-ascii?Q?fSDFhFx+4SxQTALjhOU3JL5gMPqLbGy0C2/hA8edK/83ndiCNWHvJd7W1s6l?=
 =?us-ascii?Q?Gtxd5eCIqYKuaBrnDOfQ+x5AdAd/x5k1lAht31L/WU66v+YbxQ0Ri9iu8Qrs?=
 =?us-ascii?Q?2e7Ih9xtuhTaT6Juce8rxCnUm/egEKul4GWMaUB1lvZuE+wEfX+okMN/zOO5?=
 =?us-ascii?Q?x22MVSZQAN2q3BbA1g7EAnc8Nq/k8isZrWDMsoQ1WuDM/8T8sisDxcLmiPJY?=
 =?us-ascii?Q?EzOGG43F2NPDatgsS2UILrTYIOxoxbzyCwWy+V3Px+m8jvpHYq4ik5YePgyR?=
 =?us-ascii?Q?qwgAfjyYaBE/UAGn6oWQ4Ii7Kk2NOg3pcW3cfnBgdFYxjdWxMyuqgRIKPElD?=
 =?us-ascii?Q?jnlHjqcBY8nYTmvu/2yxjMyMXTjwOq+b8J/CkmLdZvgEvs8p4AQZL/+6qI5G?=
 =?us-ascii?Q?1iG3Cz63vG4PLOkL/Mzo87U4ynWdorunTtvAH2AOJD1EkbOVREIGnk9IfBvF?=
 =?us-ascii?Q?oPUmlc/WkRfFvpQRabqpapjhycAbkfpFfIo96sCqeUZvLjKprrDhgFSgrN8L?=
 =?us-ascii?Q?fCZwkJ2GBV7tksbyub5Y6bbhFRU1xjp/11N+J+qNDFsjBGRaX/c2CZ55bDWe?=
 =?us-ascii?Q?VGfpv7eub5Jovgyq3NYN150DnZwggO/xpSb43vr+I1WGU7A9xwwu9hPa8qfc?=
 =?us-ascii?Q?J/jZ0GY56IdwKwYuuCUQpDE6sB/9SlRrp+YJB/SkuItG/aLZGWn6CUQ+pnRn?=
 =?us-ascii?Q?xSl5LmLI3rzgGvl0bAJrVNjiROyqGjXmZ1BaSirTW+AJB5dSOBrNcC6VW7tJ?=
 =?us-ascii?Q?xWJ8frLHGROVcdNQa175h1DzacB7vXrApeYDc9N/BnimJwZpVllg1b5syzxo?=
 =?us-ascii?Q?Cdp8DqzEY7euZ6vDoQpogW+I/yfzmunIeZ7tozBphGPcRu29G+NGqMEl3mlI?=
 =?us-ascii?Q?9MuH+0CgM696zfkFOWsEiXNZaUS2xTnEmS5/BZkpSBY78f0WpNwrV3kQig5D?=
 =?us-ascii?Q?7YwnWGaznYr2MNntl6RPi0Hat4rlucTVHJSOZMmGlLzj8qOMlVZz8iZ9pRP8?=
 =?us-ascii?Q?bKQxjxum6C5a5671v5lz6qSzzHuiyhglYBlsv/SElwVcP0uJ76P6tYDIOrZN?=
 =?us-ascii?Q?Mkzns+xak2cSkqz8xebAIoxEg+oXydJCx7u8+yp7Igwwswn22xDYOWYJ6TGF?=
 =?us-ascii?Q?6TObypWjVBi+iwli8JFrZaAfWMBVYteCPBzzXvNaHEIKc9JFzyTz+AYjyf2s?=
 =?us-ascii?Q?hIIJvIGYQFpub+TvSF5q4vomqgC5ZY5W2yf1wwOpS+POswl0DQU0nvtNvIdk?=
 =?us-ascii?Q?VpmIdT1syQyhEYVKfDoN2I1M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e501e6-9d42-458d-701b-08d96eb1c068
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 08:06:36.8760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TUOe7n1m72ecjirqz9A/8ELgLfIKN4VgeEmy1f5RnE/28ndLhUR4eTcf3/8+yH2zjuwBhLcPp6LWVrWn5JndGDEKTsabjP6GvVuDuTwDGGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1423
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=949
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109030048
X-Proofpoint-GUID: WS-FX_lsy-LD0Q6F_9dXzbzEySP9ekJu
X-Proofpoint-ORIG-GUID: WS-FX_lsy-LD0Q6F_9dXzbzEySP9ekJu
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 08:35:35AM -0700, Todd Kjos wrote:
> On Tue, Aug 31, 2021 at 12:24 AM Martijn Coenen <maco@android.com> wrote:
> >
> > On Mon, Aug 30, 2021 at 9:51 PM 'Todd Kjos' via kernel-team
> > <kernel-team@android.com> wrote:
> > >
> > > During BC_FREE_BUFFER processing, the BINDER_TYPE_FDA object
> > > cleanup may close 1 or more fds. The close operations are
> > > completed using the task work mechanism -- which means the thread
> > > needs to return to userspace or the file object may never be
> > > dereferenced -- which can lead to hung processes.
> > >
> > > Force the binder thread back to userspace if an fd is closed during
> > > BC_FREE_BUFFER handling.
> > >
> > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > Reviewed-by: Martijn Coenen <maco@android.com>
> 
> Please also add to stable releases 5.4 and later.

It would be better if this had a fixes tag so we knew which is the first
buggy commit.

There was a long Project Zero article about the Bad Binder exploit
because commit f5cb779ba163 ("ANDROID: binder: remove waitqueue when
thread exits.") was marked as # 4.14 but it didn't have a Fixes tag and
the actual buggy commit was in 4.9.

regards,
dan carpenter
