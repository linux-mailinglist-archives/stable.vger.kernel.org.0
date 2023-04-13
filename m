Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEBA6E1068
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 16:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjDMOwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 10:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDMOwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 10:52:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189005260;
        Thu, 13 Apr 2023 07:52:40 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33DCx1hC023288;
        Thu, 13 Apr 2023 14:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=E+jqpVOBqASvTBsdDHaW0r1He6j7Ur1b0wfhq2/21do=;
 b=hA0C9LhWqAf3IUzsUQPYLoqMKNV7Z8QlQ8evGw5izE32fQsXVicHkza/Dd4s6dCsAH+l
 bAHckWvbC7Wbf0KCxRUTQiU44FKxIEaKOuDRzAGkZQTwppVp+5cp5qoroidd66dGOQBr
 o86pB/NBynm36a20zquYmlHxlnWz+H3y9k8w1Ml3n0DLb8HXPq2nP12oehlqnqwK5oYB
 3M45XFn6F2PYFVqXfNm4L7ORsatmGDH6VaP7GgQIniLIkISO8Z58LcxRsIz6mqpYKIeG
 3fqgF3nzVldu253zU75MdqZvfFaLAtqtdsTFSOepS4F+dJqIU8lQFc/2tHv8nlB7qyaV mw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b33e2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 14:52:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33DDhRuw012551;
        Thu, 13 Apr 2023 14:52:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puweaw7cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 14:52:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjJCyIonO9ov7CoDXFmXfQ06uYahRo8pj2h0IRlIu64yBvo4bFEoVjRC30eLQdmYzVRaxg7deQnd2Z3eWOhwRF8+PNlfvh6UA4XthwABRPX+265rXsQbU67Z6CrF7lhx/RAHaCdYBVZVg4PrZXsrEONcrA7ojHCRZH6vaqnad8Y6M/uVvoQ9KRL5lEZc4WySkxgtyP5tArgeA6BFbAx89AvyJQT20WpMLDTR64o9+ubJ6PmOzEl1zIWSFf3ev9po242EiH1j77vF0MYg5K+thF16gy1F9gz893HNvznFUystA6zDM/RP5m0mMsZzH+qIouos2TTfC7Y5+JGleKeV+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+jqpVOBqASvTBsdDHaW0r1He6j7Ur1b0wfhq2/21do=;
 b=jUUs+ktlMxFox1tqaKwL8qpOoCGbUJArwv5J8M7mRfGGl9Q1p4xsPIKixZEMUs48kQM/eJohye6OCNEULcyyUkbLgj8j4iemJ93DtdQC/r1tjBZtAdCDZOmH2kKLCr1hQ47ga4JCNhKqVy8b7IV/4DMDy4tUc5xGq2zBUZWYDEqvE1IRV8B6xPb0b8Hmm1Kl/2uTvS0H0ZdfWa6CL9asGXqadQW0kzQ11yzu6OK6mEl2nN9ZQmLtrfLbxs0zQyTJ/nKdN8ypmgCSY02p+LrtIPGmsYwC8D+ZEP5mxLe3haQBOaP9ylTwRQJKuAnGTXpoclfe0nTZ/E5ltDz7oZZYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+jqpVOBqASvTBsdDHaW0r1He6j7Ur1b0wfhq2/21do=;
 b=QshAr0/YvVVDfasx1alaMnnVX4ftn5BAF0Vmg6zZdnnIIODjY35leYYQqtgl4VjJnG1VbcauKf6yrkBbBHP28a1ATBsQsvtCN0q8QW4hOtAFNReT7EB2MZgC/EklI6DQjeyFVEILcetgbnEwH4BPiOxXQB6VHs2PSTHD4bz8dfg=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM4PR10MB6839.namprd10.prod.outlook.com (2603:10b6:8:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Thu, 13 Apr
 2023 14:52:06 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00%8]) with mapi id 15.20.6254.033; Thu, 13 Apr 2023
 14:52:06 +0000
Message-ID: <06dbbe96-c90a-4466-45b2-2dcc65b04a45@oracle.com>
Date:   Thu, 13 Apr 2023 20:21:52 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230412082823.045155996@linuxfoundation.org>
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM4PR10MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 404bd0ae-63a9-46a3-c08c-08db3c2ea66e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MPC+Z4OjBMHwMg1BeciseWN53BDrcJf9gm9hfIFK2zs2/6BiimP9snclO2kzdKvoxU8dX8iz8wGcIozT4MFOWvXVjiHvnO5hTadOE61YZBIttik0Dd1JUXz+w0muPSYCI/auNdAlVk6/uu2SKiTmbWoczeyVCtSTCjAwM2bKn5ytcEZOSD7z5vWfewSHK1ZgU6yx3sxZFcG6ynxU4l6X6fG9vOIVvZsqcC1etiRR0grScmw5fKbP0wnH7aIJX/xQCk1TsdwL9QD7RBnm7pdA0vC2vee3VkLOP9lVVR81ARARc08F52NWKv4eKR7N+mR1zcNXcENsk29AFluSUj6Xcy/rmRBD4n44ApB+7zBCOCPc0zneqs+jXx8mS+qjMkh/blhNi1GHlr4OJVu8U4Q/EUSIEhGdeJNJcxM3oAPraqatLli99jhkV7+7O2eLYIJ9oLANaeg2ekWqJowHPUBhuzsJ+ysvdYPVli4qkKvhhLrDIp4GJ9LQQN3VvDLjmmhVa1D0IyFz2Zxd9iPnU8eB+PE7IHndbywE1zcK3FCuV3Ah9+28qmBXjF7evIuKWij8GeKpsOpcIau1RDV0iqBnuOMhxXzKRmYuQP4KXKeoWYoPB6VSHkpXujEbIL7Zuu1jc8zxJHn7Q3SqO/u0biXuqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(7416002)(4744005)(2906002)(31696002)(86362001)(5660300002)(36756003)(38100700002)(316002)(8936002)(54906003)(66476007)(478600001)(55236004)(8676002)(6506007)(53546011)(6666004)(26005)(107886003)(6512007)(186003)(66556008)(66946007)(4326008)(2616005)(31686004)(41300700001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWtDc250bHZmNWd1cUtVc00zWXRxa0N3YkNMeDNNVjV1SVhDNVFyd1Y1Wlo3?=
 =?utf-8?B?eVNHbTZwMWI1RFdhMzBCS2J6aHlWdDVoWXF1ZXlFYm5pZ1YrcGJ6UHZpTSsx?=
 =?utf-8?B?dnZpTjVpcFNxTXFCVnRGUUlCdC9sNkVUNExTOFcxeko3eG1hbjh4dXJmSWJO?=
 =?utf-8?B?SUhPZ3QwTjdPSWdPUGRac0lFRjl3L3dzU1hNNVEzNG5nWWhkVGZOeFBFR3Bz?=
 =?utf-8?B?VnJHeDRXandPbE9OZEdscGVVNDFCOHBSK0tVRU96TkkzOXFpSC9vbUdkUGFm?=
 =?utf-8?B?SUczR254K1UzUEs0K2ZpajB5emFCdkpsajFPOHVCR3h6dDhKNHlYQ0FmaXlo?=
 =?utf-8?B?NmhnNGJUa3FRMzREdGIwZml3VFNua3J5aHJnUnMyV0JRT1RWVGp5cmVhVGFX?=
 =?utf-8?B?Y2FpYng4ZlhaV1k4OWhCQThIaC80UThWb0djT1E2K245R21HdFBOOCtmYjRM?=
 =?utf-8?B?N200U01yQkNTdVUrMmlQc3RnTzI0SHBLM25lVVVVL0V6RjcxeGZIZ3Q1Zmpv?=
 =?utf-8?B?YVhOZjJOT0oyeVh4ZGdOcG5IQ1h4MDBpUWVmV3RVeVNPbUt6ZnNEdVVGSFNS?=
 =?utf-8?B?UW5ZT1dMaFRLUDRCalVhR3Jtc0pCZ0VHUmx4dXBIYi9ORUR2MHdIckpjRkVx?=
 =?utf-8?B?SUs4elNMSGE0Z0I4a3lxLzNVWU5vZk1lUGZ1MEt0bnBWcmV0REFBc1NWWFh1?=
 =?utf-8?B?eVNsZldKaTRacmU3Q0dyYzd3TDRrM1FnRS83MFNWdzl0VUJoOFZqbmdmU2Nl?=
 =?utf-8?B?WXVMTTFYTmswRUJoRUgxNGgwUTJGc2g4ekJ0UlFCQk5mZVV1MTZhZUhOUjJw?=
 =?utf-8?B?cGUvYVh4Zm8zcDNycVhyWFAzQk44L0JqWVRTZTkreERRTnlwRk81cmpzek9F?=
 =?utf-8?B?WFZDV3hTcEkzYnVSY3ZyT205dDFLNUhJTzl0VUNlbHVqZmFEbmFobXl0MXIy?=
 =?utf-8?B?SzlvY3dxcThPNDdxMzJCZ0NUb3JPZmg5WGdQN0VYYVBnV3lSNEZpSlBKU3ZY?=
 =?utf-8?B?N09YcTZXbnMvTGpVd01NTGxudHFXOFVOQ21LSVFTejlkc2krNjVpY25LanNH?=
 =?utf-8?B?Wi80TkltNzRIWGlnTWlmeCt3OXlXTkdjbEFFVEd1WGgzSDdwQnh4RFFwWm10?=
 =?utf-8?B?K3BWYVI1cWRRL2Y0MUdraXgrblF1V2drRjRNSm9SdEgrdGNpK2lHaStRaW5V?=
 =?utf-8?B?RmhOcUU5LzdpNmRCUWRFWXF3dGJjNW84K3UwdlJPN0UyV2tlUEd3SWtjY2FD?=
 =?utf-8?B?MnlWRTRCRENsekpiRUpZSDVmd2FPbVNhSE9ldWlzWFlUVldFYzRaSktxb3cy?=
 =?utf-8?B?WmNHY01Nb0xXNThhZSs3T3hBSGRwaGREa0xxVGo2eEFnNzI4SldpZDd3RlNk?=
 =?utf-8?B?Um4rMzNucU1Na2JzcWhSaE5uUGhGRHowcjFUVXlCemltVlNXZnY3dFVzbUZG?=
 =?utf-8?B?aUd3ZmkzdTcrcG9KQ0hGd0EzOW1VN1cwQVkva0FBWEU3aU5BRUdWaW0zRVJi?=
 =?utf-8?B?dk9BaWZvR0dQVXJiRk1ocXdVdFlGNUZnRitnU3RqVEJuUnhZb1dJTjgvQ2VM?=
 =?utf-8?B?S2E4ejgvOWhaajMzWTZsUGNYK1VMZXBLZlV5TFRKamdYSXl5aitnUE1DYXl4?=
 =?utf-8?B?Z20zWVY1U2ZxdFUxakN4TUJXMUJHTVVEZm9wWWNiWGlMQzRUY2JCQlUyUUtX?=
 =?utf-8?B?ZzgzVDZqcDNCczNHdmsvclRKVURmNzhvOVArdEd0ZE5TUGFNV2VZY2NpbkRl?=
 =?utf-8?B?M2ZyMExhNzBrTVl1T2xkdURsNTVJV3VOR1lGNlNwc2VidkZmTW10L2swOXJU?=
 =?utf-8?B?TVlHYmc3TWpLRGt5eWc5Q3lxQW50YzRtUlQxZDk1NlM3TjllWmJPbjVaaGVK?=
 =?utf-8?B?WGNqaXBvanAxLzdXOGFQQ3FJcjgwTUVnNENoME4vUkpWVnJFMnZ1L1g1MjR6?=
 =?utf-8?B?TkRTanI0UDN6K1FxeTFKMG9Wb0t2ZzJLTkw5bWo3bFVQTEwwejRsbi85b1lC?=
 =?utf-8?B?THE3MlpmenBlM3ZFbm1DQk4wenNRNW5mV0NCMElMOGJBUGFHYTg5YjNEUkdz?=
 =?utf-8?B?VzhxZ0dyd2Y1OXRWb3BsbFRjaUdaSnZvT2ZydG10elo0d0JkVWIweUdMV3Z2?=
 =?utf-8?B?aU9rT2F0K2tNNldiOXhtaVRkWTUrdThUVWtXYS8wRnUwd0ZYUnhHOGl3QXdL?=
 =?utf-8?Q?EMUp38/uZ3j9eIuNCDy8xME=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?R2xXR200SUZDRzUxeDI3amMzWDh4ZVd5WlNhdnV0S05qcFA2dEdPcGlJYVFM?=
 =?utf-8?B?RWlncHNNc2NJVHNmK1FLQzBkUytFdnIzdWJJSHlBYzU2VUVTV1J3Qks5aldS?=
 =?utf-8?B?M1pYWFVPblQxYmkraDloTXBWNk1KR1AvQzVncUppTUhnOUNUazROMWVMNkwv?=
 =?utf-8?B?NXhEdmlyOHk4RHVKNmZSWkRGUWRwalg0a1ZXbjNzRXFBUXlUdXV3Z1NXVGYr?=
 =?utf-8?B?R1VCak11azhpSDJGbTR6ak9zd21BdmRxeE5IL0FaZnhaaDhBU0N3byt0TzNi?=
 =?utf-8?B?c3BDM2prZkZqNm9TUUJpNEhTcTRJOFpaekpSNy9YemdnNTgyUDFvMUV0UnBs?=
 =?utf-8?B?OUlsZmJDSi9qQTFMVXRXMHVxQmphSGZibXpkQjVzNU9zZWVyOWRSKzBCaEJw?=
 =?utf-8?B?eGpoYW15aDN0TldOS3UrK2lhTUJLTzRyQnhoaHcvUVNQVmhPNjZseFlUU2NG?=
 =?utf-8?B?K0Vtb1N1Y2wraWc4YUFsT1ZxVWNMRkhWRHRqQmRsQ0I5Q0kxTGpUTFIwYTNn?=
 =?utf-8?B?alBycCs3UjNveGZTak8xWHFFUUM3T1RWTmFaNG9odlNWZlpaWVNERGIwZjc0?=
 =?utf-8?B?S2JlZWYwYW9TeWMyVHdSbkl3M2VWMkppNXJUMk85c2JqZ002RlJQaWh0QnUv?=
 =?utf-8?B?YmJJWmpTa2pKNVJDekE0eVY2OTlHaEJxZjlUeEE4bjFMWERRS1ExUkJmeHQx?=
 =?utf-8?B?Y2xnS0l1SzZya3pJNGRVZjZER3NDNnU4VXg1UGFFMGp2YXVob0kvUFNxc2pF?=
 =?utf-8?B?TVdGR1RSUTNCNEVBc294dFZTU28vZE1VYnNGRVdMM0Zrc0J5VmhyNFArNGFs?=
 =?utf-8?B?WjkyY0xHdEdlZ0NOTUFwSXh3UjdaUEh2YnV1L3dQUjZORThoK3JSY3duY3hz?=
 =?utf-8?B?eXlua240MHhqbmM5T1dIcXR0V0F2ZnRFN1B0RkJHem5rcnEzZlRQSi91TWtm?=
 =?utf-8?B?dGtCa3NuUHBldEczRlV1VEVxWlpsMDlkQmxZejcySUFuV25UR2JvZnRBczJz?=
 =?utf-8?B?ZWNRazR3WmJaRkhsWHArZnBBS2hoUUtiWk9haFVvb0dVSkVjSm5UdGRkaEVB?=
 =?utf-8?B?SnBQZ201YnlQUW1May90aGxYNUo3WG9UeHkzdkd3OWdPb242TktKeFEvQXJ1?=
 =?utf-8?B?b2FxOHVEM0swVVZkRjYvYnhlKytiMXRaanhkM2sySll4THBPc0p0YkdpRk1U?=
 =?utf-8?B?QlI2eUZKVjhNNExza2JYS3M3QjVvUWxYTFZjMmhPQjh1OWJBMFJzNUxhbHQz?=
 =?utf-8?B?NStpTTIzdXFWVXp1TzhEOXBIVXZPcnZNYmJoeHExWDB2WWZZQXZ5dHZoby9Q?=
 =?utf-8?B?MDNscnZTVkFNdUR1U3o3Nm9jUUVzRzhOd2wvTU9Db1hBKytMOXpyd0Npd3gv?=
 =?utf-8?B?NWNUb3NlZXRvVXhVQWpENWtLSTlwdUl4LzZxYWJVRGZQYUxGNUdJbE5QUS9i?=
 =?utf-8?B?OTQvaVF6M1BJQ3J0Y0JDMzA0YVlMODdlc25YeWhVVXhBL29QMG14TEZ3Q2lm?=
 =?utf-8?B?Yld3WUtQd0xzYU1YckFRdVhjbXJrOG5EZk1jOXkwNmVxU3VaZ1JkS1gxMTN6?=
 =?utf-8?Q?Ek6t0iGWXeMfYUDoXxEJBX98tamBAMN2rIWRcqAFa+M5Sj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404bd0ae-63a9-46a3-c08c-08db3c2ea66e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 14:52:06.5087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pRAMsNQ4SE4Dq7TL2IFFctou2IW9qvp9gDr3vf71qFSlwOrAJ9WGDQQ6blKL3L5FjYybxDaTCY6JZYYa3CWPfy+nH415G8s0+DW5/WyBA5Z7aK9PXNqi22vp/QVST95
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_10,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=938
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130132
X-Proofpoint-GUID: cKdVjaYFgPgTK0erIYG4jcaMo5a7pQTG
X-Proofpoint-ORIG-GUID: cKdVjaYFgPgTK0erIYG4jcaMo5a7pQTG
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 12/04/23 2:03 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems seen on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
