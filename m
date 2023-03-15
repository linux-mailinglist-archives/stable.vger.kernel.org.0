Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07516BAAFA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCOImz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjCOImw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:42:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668D06BC1D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:42:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32F8Iqvo027733;
        Wed, 15 Mar 2023 08:42:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=b2HGLUjLbvWdBk7/Aci2cT8RC7O7ZKkBKAIltWeN44M=;
 b=jsTdofgOvXEReSTr6dztA7vizMg58tqI8ZglDhhegjbpcy6QWqVgDyhontxFc2JtM27J
 MOum48N17pkdjG5PUxAcZy4Tr+5DH8L2LMHi3DNwiGwFQAdQtNG6xpGrz94SYjAvetbE
 gtPbBDsxftjU3mtyw6a1dFrf3UFHuCPpDLAl228dTDXEc2Iw8I/ExWGXYTMc2eE6eLGX
 lhSF1JvL1m19YlPQomy3BFWNjtWOWDADaKr0jbXVjZiBMptpCNBNkSf1a/H6rw8AZVqR
 plmogQ7YQ7LIDzskBKBgt7jdW3J12c65WH3cXNTfNOlChckZ9OYRpPPedCmDmdtXKdiC RA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2c1rsq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 08:42:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32F8eg5Y038313;
        Wed, 15 Mar 2023 08:42:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2w80qwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 08:42:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mY85AGLQP7q8/y1V424QA5RuSHjiHBoZ0texIB9IssaDAgekkQ0DMYzglJToX8pgDxOtj256GwuhrT+zpwgwSOYSLrv1Hs1mafbbqQVqYAiYovOiovPiGX+oFs/zkq5mCriT+QEF6sGdnegtid8TzIe0LpkjOi0sraZbVGoWxj7RjPYEj5dCmtHLj0qA7RaoIBN9RKNwHs0pFPzXD12ZFDWkLusXUYJ4WApeip0HSL6bBOCha7kN40oDToMWO6JJ86fWhyXQqHsFFpaAbIpw9hP0yY45oC8zNlqB9JhMMrghcC/nkvwlL/vmOgHPvJ5rnd/h60R4ifkTFxz7QB1dNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2HGLUjLbvWdBk7/Aci2cT8RC7O7ZKkBKAIltWeN44M=;
 b=imjcS28CwyKyziBGvSUEw3B464LZCmbEQg53gA33oQ7aune1ytvS7ILwKjoWMYICvijPr7P3zWbPbzsQRRFfH9U184JL23kwJZnxiQVfGmJXBXOHpnYavqG1/lB/zwX94DrY7QfsKGTI7R96jiKP5+UJEJ82SbDV5VS71HRdsAzrc4SDTiPSSR4Se/UJZf7rS1eRvzN+jnmCFDlqnH+B8nKSN7qGaL8J5Uoet+hOwrIJbPoZnrfIqq8u+1EZQq85bQEWi3WnNZod9rnEcAsZbzh17YB3IrPQv5Ohy94MgX1JGsxU9OSoEaeYxVau8nPdtz1u3C/npSGrD31JlAzH8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2HGLUjLbvWdBk7/Aci2cT8RC7O7ZKkBKAIltWeN44M=;
 b=bMkjBxMNKsnrrqbZP73OE6bIu3AGf8bGKnjmvqmxHyqcFTK3+DnYUsInRCbVQD8l92Jtj8naIMLTXPR/1GTu8ZvxxvwJgpIxtKjwmAOxZU8S3aA1xOgme9qIWCicPZe7HBblrgLt0/q92Dt+Vy1P1SDSJuemAEZhNAqLcsXciP4=
Received: from BLAPR10MB5380.namprd10.prod.outlook.com (2603:10b6:208:333::14)
 by BLAPR10MB5137.namprd10.prod.outlook.com (2603:10b6:208:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 08:42:17 +0000
Received: from BLAPR10MB5380.namprd10.prod.outlook.com
 ([fe80::e403:a34a:e37f:7ce9]) by BLAPR10MB5380.namprd10.prod.outlook.com
 ([fe80::e403:a34a:e37f:7ce9%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 08:42:17 +0000
Message-ID: <d7c7edde-b358-a9ab-e2ae-6f11ade2d871@oracle.com>
Date:   Wed, 15 Mar 2023 14:11:57 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [External] : Re: [PATCH 4.14] x86/cpu: Fix LFENCE serialization
 check in init_amd()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de,
        pawan.kumar.gupta@linux.intel.com, cascardo@canonical.com,
        surajjs@amazon.com, daniel.sneddon@linux.intel.com,
        peterz@infradead.org, stable@vger.kernel.org
References: <20230314111159.3536249-1-rhythm.m.mahajan@oracle.com>
 <ZBF6XaeboXtY6VS5@kroah.com>
Content-Language: en-US
From:   rhythm.m.mahajan@oracle.com
In-Reply-To: <ZBF6XaeboXtY6VS5@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0012.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::15) To BLAPR10MB5380.namprd10.prod.outlook.com
 (2603:10b6:208:333::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5380:EE_|BLAPR10MB5137:EE_
X-MS-Office365-Filtering-Correlation-Id: 46f7b2c9-b0cf-4017-9338-08db25312e9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +wx90O3HMZEIQLqu1gasfolfcKzYnGgYf54n6TUvvNJxvzBdaHd4+ELAvCa6zAOL+4sIbuObNqjs13bzuanNTeByXZ12scxW0cw1cS3uOy1N0E1EwbBFotaiQHOt1IfZpjFFUKg4bYhJ9TNZui3lskPDObxpTW8FpoXubcYTchwYhA02h/xM0tKyoc0BoY0rL5U/5pBLxIF6VRGpL/qHTyW1pF0yzyh0FOtSaOnDrVcuLzufFizU8iCAoWQOdUrCZpsxdVEqteu4kKSNCaFj1H3bFUlYpsNCcE8GwxyYmQ8VbQ5sDXT2GZbY2bFJqZJjLhrozeiJP16BUmtgdfuB+aGjtRE58fyefluQxaX76c4wEtnuMPksSiVSW/Qkm301zeAITzWRQIg/C5CrcRYXPHUlbGmQ5Q9ag3i1e3Men4hV84ZGfledItbUFJQU1buUIqnp/j+KpFtzcdUWfSP+cx7wNjAlfoYBixpy4V/PGe5j9zYlAddTRBOXey0ubRqxnL7Pw/9MgMuGcaa90Bdc8ePU7chNKlQLa7Xg6N6T38z1rN4hJPAUz1zW4f67DXie9Y9goe9erUGz4NjYoZVg0TZefby7d0Qitgmkhf6hTE3mYofYLGAq5T28bOx2X3WQJlLle5Cmt9+/WIRQqhb3VsBYi0Xbelmv/R6uecMK6b/imC9d/dCTmKYa+U8pBrBqBlJ7a5ErUfoMVSEV9Ikh8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5380.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199018)(6512007)(9686003)(2616005)(38100700002)(2906002)(86362001)(186003)(26005)(5660300002)(6506007)(7416002)(31686004)(53546011)(8936002)(31696002)(6666004)(316002)(41300700001)(4326008)(6916009)(478600001)(8676002)(66946007)(66476007)(6486002)(66556008)(36756003)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTUwanhhZjcxZWlGd2NmMkYyeCtkTVgwS1hMWk5nSzB6T1g4aW1rc0RWWDMr?=
 =?utf-8?B?ZXV2ckUyU1JiMnJtU2kvUlBjbnNXd2pMT1kzcERhY1JBVFAyT2xReFNwTkVk?=
 =?utf-8?B?d3VYZkg5VjdYdjU5QTJOa3lIL253cnhYQXoxWmpZdjFQYktuMHpabnZIWWhn?=
 =?utf-8?B?Q3Y4NFlJVFM3SG9lejlYaVZ4ZTBBQWNrS2dvb0M3WVRPc1NEV3lYRzFoczc4?=
 =?utf-8?B?QXp1OVlQRVI3eXpKNG5xQW9aVDl2cVJ0S3paWjhvbWhvNWJOdTNXY0Q2d2Zj?=
 =?utf-8?B?ZzZGVDFsZjM1Slk4a2dYM2hWUGdWeXdCWkFxMDJObGdpeDRJanFmRS9KNDJR?=
 =?utf-8?B?d1dmcnM5MzFlcUNURlBteWxFOUlBczNHU1Rzak9jalF3bzdINHo4eVhzWnhR?=
 =?utf-8?B?NjBtL055bXU0aHREWDNJejdxcWZmZHFzcGNUazBQNG9lQ2tVdzFEakRobU9Z?=
 =?utf-8?B?RmE3YVVkWTRtL2MxSHB3bjZ1R0VYMW5VU1lmL2NYd2RndmQxM0hrUStibEFm?=
 =?utf-8?B?bkM1aWk2czFNQ1RDL1U1YTFhVnpKZ2E1elRwLzliSzJvK2k1dXM2Q0NzZmhm?=
 =?utf-8?B?a20wZ09MdkJiZllkM3doZncrR1FqSU8ySDNxU3hTYjJ6OWFsdGdSOEdZSVNi?=
 =?utf-8?B?UHFJQzRnZzlCSU9jSE5rRmZCa2oyNU9lUDBGeTJOUXJ0Uko4aUEwNG9rbFM2?=
 =?utf-8?B?dzdoekpERStiaUN2Wjd3S2JZZG9QKzlWb1Q0OVZ6V293NzBPNUZnUzMxNHFt?=
 =?utf-8?B?ZkY5MkllOTROdnFQNnp0dG9USGF2a3JTOWp0NFdSeVUwN21MRDlOUkpHTG9h?=
 =?utf-8?B?QjNMOWt6L0VneFpHRXZWZkkxdDJHNWNHaWoySkJ5WVJDMWU0TVFHQ0tUbzdv?=
 =?utf-8?B?eThhZEdKUlpOaUhpSy9TK1Z0MG5yWFM5bFJDVXZMTjE3MlFCWVlEdGJwaVdo?=
 =?utf-8?B?enVKaHgzTDE0NndudGFtbFZKTzQ5OGZrVlMyY2NNYzMyYlQvejR4MVlxbTlJ?=
 =?utf-8?B?cVVabVcwYWEyZnNXaFp6SGhBQThoSlZhTklXdGxMbXQ0YXBqZjJGdml1MVVJ?=
 =?utf-8?B?NjY4OEdLL2tzUnZuYXdqZHphRk9UTjJlV2RRYW9JWDNNYTBlKzBzcTlzQ3h0?=
 =?utf-8?B?TFV0anY1V05rb2F5TjBqUmZQS2tycXJmSytpV2s1ZlRZUW9XU0lZUHJXRjVV?=
 =?utf-8?B?RW1aRWZ1aXNGQXFad29oZkM0Tjd0OWJCczJ1S0ZibGw5Vm0zN2RPaFhhMG44?=
 =?utf-8?B?dDdPNDRHdGJCUUtDVTdXYkgvT1NGL0JzWkNJOVIxOU9uRlJmS2RUaUl1NFFF?=
 =?utf-8?B?QW9PSTVBMEVwY3BLUVhLQnU3clVxNVFndG5xeWVOK3F2TXdzSjE4MkpFZHVy?=
 =?utf-8?B?WHRaWWhMaEE2MWQxQnV4SmxUbHpNWE9uWWEvZWpjQXdhVUJmdnZtbklwT2kv?=
 =?utf-8?B?aktzNnliTDNLcUthOUlPTUJaL0w0Q091NUgya0ljWHB3RzZXdEcyS3hIQ25U?=
 =?utf-8?B?YmxBblNMOG9rSW13bzBCNzBtcVZkYzJTUWhKekR3aW1PRXErR3g5SDZjbml6?=
 =?utf-8?B?VEdJelZHajNYcXJMUTcvMzhFSlkxZC9sTklpbGZGWHFmOWQ2Ni8vMHp3QUhz?=
 =?utf-8?B?dVlGcERDRWgrYm9wWk9OUFh6ckF5dGJCVlRzdG5JSUtleTN3MFl5T3ExcWt5?=
 =?utf-8?B?VGVzZmNyTVI1d0FOSkowdUJKQWEvdkx4T21EZjdaY0pHV0crZ3plY2RyRkZt?=
 =?utf-8?B?YXo3UW00SmY4ZWxNd2MvcXJlSDZ6MXFyV2xSRFVkOFh3b25PYnpUZTcyZGt0?=
 =?utf-8?B?a2ZsTGx1dU8vU3VjNHhVMS9QZDQvMWhyYlRONlBNZG16NkRyYTBiVG1WbGxp?=
 =?utf-8?B?b0EveDUyTWVYckhubW9GRmVyemExOE5FbGlXTWtQZ0ZXakdqWGNkMEhKd0hW?=
 =?utf-8?B?WjZSS0F1SVRaSW5LV3lmbHRuZ2JuNW55QWI0QWZuREpXRlNxT0xJQTEwYmhq?=
 =?utf-8?B?SHl1eWM4eXBhNEpOd1dVcmM3aWlGbE8xN0hqRWd6b1d0enlSZkNOeTJtRi9O?=
 =?utf-8?B?cnRXVDBiekQxU3lrdjNTcXlOZXc4emVHbktXZGVpMlU3MjFLZzA0SnZ1N3hi?=
 =?utf-8?B?UEs3TFdSVXJwU0Z3U3VlVTBKUDYwNWFJM2hDMjl6YjJDNXJMblJyT24yeDZr?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?amJNa1hjWU93NTcwUlNrMkJydTU5T2RpSlNKUXRscEozQjhvcVhJZ01hVXln?=
 =?utf-8?B?aTFYdFNya0pmUnNjWkw1eDljQzdJeXVCVkg5UUNyblUzSW5TYVBrZnJ6V1Qv?=
 =?utf-8?B?eGRVcW91UnphdmZ4WjU2UnlWcEcvOE1IWnJ6RVhNM1RpbDg5ajFvbE1CbDJp?=
 =?utf-8?B?K25VMThQTnRIa21aSnF6cUpZQnNtcGRxQlZrNGp0NEdjY3lNc1NRZG5kdXVr?=
 =?utf-8?B?M3lzSkR3Q01TWGFhR051RTZvR3ROWTZEMXJ4VGZFTVlzVkZGcEQrRDQvTUtS?=
 =?utf-8?B?ckt5elR2TnRudk9zZXhraGNWWXJjMC9ZY1A4S2R5aWhHL29MUXBzQldsUlp2?=
 =?utf-8?B?L2VRWGFxOU1kUi9zeVhjcStrenlsNUV3WVdNaThIeHE5SlV5TkIxUkl4QTlI?=
 =?utf-8?B?QVh2TE1sNUxEWTJ0RTF6eDZxcVJoaWh6UVhHdHBhdmtaYWRJSW1MZEJMY29M?=
 =?utf-8?B?R0VGcW54N1RhcjlDcjNZR3l3aEVqbndHNDI4allQbDM1MlMydVZSRW51ejZD?=
 =?utf-8?B?TTdJVDZhTGh5V3dUTnlrWmpvYVdNa3dYTUNmalJ2Q1FEVEtZN0N2U1daa3Vq?=
 =?utf-8?B?UVVITldDbGVkekw0S3FIc2V6dGlWTVBkdFh6MHZwQVNkMW9mWWkzSGw1aDdT?=
 =?utf-8?B?RFY5VFJpMytLdjNZMVNQNFpqSUFFdnNsU2poYUtuSXk0MG9MUWFqWDA2RHRL?=
 =?utf-8?B?Y3NyMktaZ21JRGZpenJqL2lVVFFHWjNQZlkxR3hNaXhZMkRrcExYRXFaQmxI?=
 =?utf-8?B?KzNBTE00ZGJWS0g2VThvck5JY3prbTN0eUxxb1hhUzg4eGNhY3hFaDJUQ0pJ?=
 =?utf-8?B?clZPaEx0QUVJTm15SmVqQ1JBN0NyaldVOENMS29KMkRTakZCVk5iMmVuREdR?=
 =?utf-8?B?SDhKMnR1NHE0WG9EYzVlZHNwVUMwbU13ajZtdi9SOHVhaFdSSjZvWHhsUXZD?=
 =?utf-8?B?Q3N0VTFQdnZ5TE5qaFU4R0V0cDdJN1FoblVIcUJsZDdhRVdHMHNJT0J0R0g5?=
 =?utf-8?B?STRUd3JXQ1JIMytwaXEwUnc1aGJYQVRMSllZc3B4Rk1rRzlGOFl0UUpsc0dS?=
 =?utf-8?B?UVphMUtHb3hxRHBMOVFmeHovZTN3Z1NtZjRZSzRKWGpYVENQMzU1a2VxVjlG?=
 =?utf-8?B?eXlkSENKZ0VoYWxraklxdW5aQW1DZGl0N1o3R3JnRXFFMUFMT08rRWhvRkEv?=
 =?utf-8?B?b2E1OWV0aVg4Y0tpeStJT0tYZHQ4Q0NkM3c2RklnMERrcWJua096UEZrLzl1?=
 =?utf-8?B?U2hXK0dELzlGNTlBNGxLYVRIMXVFNHZQLzY5aFVFYks4eVQyRU5uNlVibnVG?=
 =?utf-8?B?b1UvUUE3NDF3N1FkaFNMUUZMaVM1NUZzTmNETHF1bVdRNnJYN3Jsb1hsTVlM?=
 =?utf-8?B?ZWdFUlhOTkJuMXp5RFF0MEt5RkFFS0g1Rm5BWnVBdlRQMGhiaUJvcW5ZTXhL?=
 =?utf-8?Q?pUQuuD0P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f7b2c9-b0cf-4017-9338-08db25312e9f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5380.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 08:42:17.2229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bV7I/QkOcHE+aUMI/mBTtE79NPZe5zqViPIqWNjvjFMKgjod+o4H1thLwtVjZ9w47f86fDnrIRKQHr0/3qPQv1FR5FRV1zk/kNGnODDvtRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_04,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150072
X-Proofpoint-GUID: E67gBVQT7NG1DJ4eJVtxIfkSDL-YJMUB
X-Proofpoint-ORIG-GUID: E67gBVQT7NG1DJ4eJVtxIfkSDL-YJMUB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 15/03/23 1:27 pm, Greg KH wrote:
> On Tue, Mar 14, 2023 at 04:11:59AM -0700, Rhythm Mahajan wrote:
>> The commit: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
>> renamed the MSR_F10H_DECFG_LFENCE_SERIALIZE macro to
>> MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
>> The fix changed MSR_F10H_DECFG_LFENCE_SERIALIZE to
>> MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in the init_amd() function,
>> but should have used MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
>> This causes a discrepancy in the LFENCE serialization
>> check in the init_amd() function.
>>
>> This causes a ~16% sysbench memory regression, when running:
>>    sysbench --test=memory run
>>
>> Fixes: 3f235279828c2a8aff3164fef08d58f7af2d64fc("x86/cpu: Restore AMD's DE_CFG MSR after resume
>> ")
> 
> Odd line-wrapping :(
> 
> And please use the proper way to reference SHA1 as documented in the
> kernel documentation.
Thanks, I will send a v2 for this.
> 
> And why is this only needed in 4.14.y?  What about Linus's tree and all
> of the other stable trees?
The regression was introduced after the backport of 2632daebafd0 
("x86/cpu: Restore AMD's DE_CFG MSR after resume") for 4.14.y and 4.9.y.
Mainline and other stable don't have this regression.
The fix is only needed for 4.14.y and 4.9.y.
> 
> Please get this fixed in Linus's tree first and then we can take a
> backport.
Mainline doesn't require this fix.
> 
> thanks,
> 
> greg k-h

Thanks,
Rhythm
